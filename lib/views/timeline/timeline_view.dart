import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familicious/managers/post_manager.dart';
import 'package:familicious/views/timeline/create_post_view.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import 'package:timeago/timeago.dart' as timeago;

class TimeLineView extends StatelessWidget {
  TimeLineView({Key? key}) : super(key: key);

  final PostManager _postManager = PostManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Timeline'),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => CreatePostView())),
              icon: Icon(
                UniconsLine.plus_square,
                color: Theme.of(context).iconTheme.color,
              ))
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>?>>(
        stream: _postManager.getAllPosts(),
        builder: (context, snapshot) {
          return ListView.separated(
            itemBuilder: (context, index) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data == null) {
                return const Center(
                  child: Text('No data is available'),
                );
              }

              return Card(
                elevation: 0,
                color: Theme.of(context).cardColor,
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder<Map<String, dynamic>?>(
                          stream: _postManager
                              .getUserInfo(
                                  snapshot.data!.docs[index].data()!['user_id'])
                              .asStream(),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState ==
                                    ConnectionState.waiting &&
                                userSnapshot.data == null) {
                              return const Center(
                                  child: LinearProgressIndicator());
                            }
                            if (userSnapshot.connectionState ==
                                    ConnectionState.done &&
                                userSnapshot.data == null) {
                              return const Center(
                                  child: LinearProgressIndicator());
                            }
                            return ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                    userSnapshot.data!['picture']!),
                              ),
                              title: Text(
                                userSnapshot.data!['name'],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                timeago.format(snapshot.data!.docs[index]
                                    .data()!['createdAt']
                                    .toDate()),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey),
                              ),
                              trailing: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.more_horiz,
                                    color: Theme.of(context).iconTheme.color,
                                  )),
                            );
                          }),
                      snapshot.data!.docs[index].data()!['description']!.isEmpty
                          ? const SizedBox.shrink()
                          : Text(snapshot.data!.docs[index]
                              .data()!['description']!),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          snapshot.data!.docs[index].data()!['picture']!,
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                color: Theme.of(context).iconTheme.color,
                                onPressed: () {},
                                icon: Icon(
                                  UniconsLine.thumbs_up,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(UniconsLine.comment_lines,
                                      color: Theme.of(context).iconTheme.color))
                            ],
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                UniconsLine.telegram_alt,
                                color: Theme.of(context).iconTheme.color,
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: snapshot.data == null ? 0 : snapshot.data!.docs.length,
          );
        },
      ),
    );
  }
}

// class TimeLineImageWidget extends StatelessWidget {
//   const TimeLineImageWidget({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 0,
//       color: Theme.of(context).cardColor,
//       margin: const EdgeInsets.all(16),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             ListTile(
//               contentPadding: const EdgeInsets.all(0),
//               leading: const CircleAvatar(
//                 radius: 30,
//                 backgroundImage: NetworkImage(
//                   'https://images.unsplash.com/photo-1584090170129-4d74e3634910?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=880&q=80',
//                 ),
//               ),
//               title: Text(
//                 'Attaa Adwoa',
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyText1!
//                     .copyWith(fontSize: 18, fontWeight: FontWeight.w600),
//               ),
//               subtitle: Text(
//                 '1 Minute ago',
//                 style: Theme.of(context).textTheme.bodyText2!.copyWith(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey),
//               ),
//               trailing: IconButton(
//                   onPressed: () {},
//                   icon: Icon(
//                     Icons.more_horiz,
//                     color: Theme.of(context).iconTheme.color,
//                   )),
//             ),
//             ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Image.network(
//                 'https://images.unsplash.com/photo-1584090170129-4d74e3634910?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=880&q=80',
//                 height: 200,
//                 width: MediaQuery.of(context).size.width,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     IconButton(
//                       color: Theme.of(context).iconTheme.color,
//                       onPressed: () {},
//                       icon: Icon(
//                         UniconsLine.thumbs_up,
//                       ),
//                     ),
//                     IconButton(
//                         onPressed: () {},
//                         icon: Icon(UniconsLine.comment_lines,
//                             color: Theme.of(context).iconTheme.color))
//                   ],
//                 ),
//                 IconButton(
//                     onPressed: () {},
//                     icon: Icon(
//                       UniconsLine.telegram_alt,
//                       color: Theme.of(context).iconTheme.color,
//                     ))
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
