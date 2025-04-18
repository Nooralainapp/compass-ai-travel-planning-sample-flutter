// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../common/themes/text_styles.dart';
import '../../common/widgets/tag_chip.dart';
import 'package:flutter/material.dart';
import '../../activities_feature/presentation/activities_screen.dart';

import '../../activities_feature/models/activity.dart';
import '../../activities_feature/view_models/activities_viewmodel.dart';
import '../business/model/destination.dart';

class ResultCard extends StatelessWidget {
  const ResultCard(
    {super.key,
    required this.destination,
    this.isSmall = true,
  });
  
  final Destination? destination;
  final bool? isSmall;

  @override
  Widget build(BuildContext context) {
    if (destination == null) {
      return const Card(
        child: Placeholder(),
      );
    }

    final imageUrl = destination?.imageUrl ?? '';
    return GestureDetector(
      onTap: () {
        if(destination == null){
          return;
        }
        context.read<TravelPlan>().destination = destination;
        context.read<ActivitiesViewModel>().search(location: destination?.name);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ActivitiesScreen(),
          ),
        );
      },
      child: isSmall == true ? _buildSmall(context, imageUrl) : _buildLarge(context, imageUrl),
    );
  }

  Widget _buildSmall(BuildContext context, String imageUrl) {
    return Card(
        child: Stack(children: [
      imageUrl.isNotEmpty
          ? FadeInImage(
              placeholder: const AssetImage('assets/images/image.png'),
              image: CachedNetworkImageProvider(imageUrl),
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) {
                return const Placeholder();
              },
              placeholderErrorBuilder:(context, error, stackTrace) {
                return Container(color: Colors.grey[300]);
              },
            )
          : Image.asset(
              'assets/images/image.png',
              fit: BoxFit.cover,
          ),
      Positioned(
        bottom: 12.0,
        left: 12.0,
        right: 12.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              destination?.name.toUpperCase() ?? '',
              style: TextStyles.cardTitleStyle,
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 4.0,
              runSpacing: 4.0,
              direction: Axis.horizontal,
              children: destination!.tags.map((e) => TagChip(tag: e)).toList() ,
            ),
          ],
        ),
      )
    ]));
  }

  Widget _buildLarge(BuildContext context, String imageUrl) {
    return Card(
      child: Stack(
        children: [
          imageUrl.isNotEmpty
              ? FadeInImage(
            placeholder: const AssetImage('assets/images/image.png'),
            image: CachedNetworkImageProvider(imageUrl),
            fit: BoxFit.cover,
            imageErrorBuilder: (context, error, stackTrace) {
              return const Placeholder();
            },
            placeholderErrorBuilder:(context, error, stackTrace) {
              return Container(color: Colors.grey[300]);
            },
          ): Image.asset(
              'assets/images/image.png',
              fit: BoxFit.cover,
          ),
          Positioned(
          bottom: 32.0,
          left: 16.0,
          right: 24.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                 destination!.name.toUpperCase() ,
                style: TextStyles.cardTitleStyle.copyWith(fontSize: 32),
              ),
              const SizedBox(
                height: 6,
              ),
              Wrap(
                spacing: 4.0,
                runSpacing: 4.0,
                direction: Axis.horizontal,
                children: destination!.tags.map((e) => TagChip(tag: e, isSmall: false)).toList(),
              ),
            ],
          ))
          ],
        ),
    );
  
}
} 
