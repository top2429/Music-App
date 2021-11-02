import 'package:audio_service/audio_service.dart';
import 'package:blackhole/CustomWidgets/snackbar.dart';
import 'package:blackhole/Helpers/playlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LikeButton extends StatefulWidget {
  final MediaItem? mediaItem;
  final double? size;
  final Map? data;
  final bool showSnack;
  const LikeButton(
      {Key? key,
      required this.mediaItem,
      this.size,
      this.data,
      this.showSnack = true})
      : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool liked = false;

  @override
  Widget build(BuildContext context) {
    try {
      if (widget.mediaItem != null) {
        liked = checkPlaylist('Favorite Songs', widget.mediaItem!.id);
      } else {
        liked = checkPlaylist('Favorite Songs', widget.data!['id'].toString());
      }
    } catch (e) {
      // print('Error: $e');
    }
    return IconButton(
        icon: Icon(
          liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: liked ? Colors.redAccent : Theme.of(context).iconTheme.color,
        ),
        iconSize: widget.size ?? 24.0,
        tooltip: liked
            ? AppLocalizations.of(context)!.unlike
            : AppLocalizations.of(context)!.like,
        onPressed: () {
          liked
              ? removeLiked(widget.mediaItem == null
                  ? widget.data!['id'].toString()
                  : widget.mediaItem!.id)
              : widget.mediaItem == null
                  ? addMapToPlaylist('Favorite Songs', widget.data!)
                  : addItemToPlaylist('Favorite Songs', widget.mediaItem!);

          setState(() {
            liked = !liked;
          });
          if (widget.showSnack) {
            ShowSnackBar().showSnackBar(
              context,
              liked
                  ? AppLocalizations.of(context)!.addedToFav
                  : AppLocalizations.of(context)!.removedFromFav,
              action: SnackBarAction(
                  textColor: Theme.of(context).colorScheme.secondary,
                  label: AppLocalizations.of(context)!.undo,
                  onPressed: () {
                    liked
                        ? removeLiked(widget.mediaItem == null
                            ? widget.data!['id'].toString()
                            : widget.mediaItem!.id)
                        : widget.mediaItem == null
                            ? addMapToPlaylist('Favorite Songs', widget.data!)
                            : addItemToPlaylist(
                                'Favorite Songs', widget.mediaItem!);

                    liked = !liked;
                    setState(() {});
                  }),
            );
          }
        });
  }
}
