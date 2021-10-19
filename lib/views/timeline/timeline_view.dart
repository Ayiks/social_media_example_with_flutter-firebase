import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class TimeLineView extends StatelessWidget {
  const TimeLineView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Timeline'),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                UniconsLine.plus_square,
                color: Theme.of(context).iconTheme.color,
              ))
        ],
      ),
      body: ListView.builder(itemBuilder: (context, index){
        return TimeLineImageWidget();
      }, itemCount: 10,),
    );
  }
}

class TimeLineImageWidget extends StatelessWidget {
  const TimeLineImageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              leading: const CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1584090170129-4d74e3634910?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=880&q=80',
                ),
              ),
              title: Text(
                'Attaa Adwoa',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '1 Minute ago',
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
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
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                'https://images.unsplash.com/photo-1584090170129-4d74e3634910?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=880&q=80',
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
  }
}
