import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/jobs/add_job_page.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/services/database.dart';
import 'package:time_tracker/widgets/platform_alert_dialog.dart';
import 'package:time_tracker/widgets/platform_exception_alert_dialog.dart';

class JobsPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      await auth.signOut();
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Signout Failed',
        exception: e,
      );
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignout = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout ?',
      defaultActionText: 'Logout',
      cancelActionText: 'Cancel',
    ).show(context);
    if (didRequestSignout == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => AddJobPage.show(context),
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final jobs = snapshot.data;
          final children = jobs.map((job) => Text(job.name)).toList();
          return ListView(
            children: children,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}