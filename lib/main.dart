import 'package:flutter/material.dart';

void main() {
  runApp(const ThesisTrackApp());
}

class ThesisTrackApp extends StatelessWidget {
  const ThesisTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ThesisTrack SLR',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6A1B9A),
        scaffoldBackgroundColor: const Color(0xFFF8F5FB),
      ),
      home: const ThesisHome(),
    );
  }
}

class ThesisHome extends StatefulWidget {
  const ThesisHome({super.key});

  @override
  State<ThesisHome> createState() => _ThesisHomeState();
}

class _ThesisHomeState extends State<ThesisHome> {
  int _pageIndex = 0;

  final List<StudyRecord> _studies = [
    StudyRecord(title: 'Deep physiological emotion recognition for remote healthcare', source: 'IEEE Xplore', year: 2024, modality: 'Physiological', decision: 'Included'),
    StudyRecord(title: 'Facial expression analysis for pain assessment', source: 'ScienceDirect', year: 2023, modality: 'Facial', decision: 'Included'),
    StudyRecord(title: 'Emotion recognition in smart classrooms', source: 'MDPI', year: 2022, modality: 'Facial', decision: 'Excluded'),
    StudyRecord(title: 'Multimodal affective monitoring with cloud analytics', source: 'Springer', year: 2025, modality: 'Multimodal', decision: 'Screening'),
  ];

  final List<WritingTask> _tasks = [
    WritingTask(section: 'Introduction', title: 'Clarify healthcare motivation', done: true),
    WritingTask(section: 'Methods', title: 'Align search strategy with PRISMA', done: true),
    WritingTask(section: 'Results', title: 'Check taxonomy counts and percentages', done: false),
    WritingTask(section: 'Discussion', title: 'Discuss IoMT-cloud integration gaps', done: false),
  ];

  final _titleController = TextEditingController();
  final _sourceController = TextEditingController(text: 'Scopus');
  final _yearController = TextEditingController(text: '2025');
  String _selectedModality = 'Physiological';
  String _selectedDecision = 'Screening';

  @override
  void dispose() {
    _titleController.dispose();
    _sourceController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _OverviewPage(studies: _studies, tasks: _tasks),
      _StudiesPage(studies: _studies, onAddStudy: _showAddStudySheet),
      _PrismaPage(studies: _studies),
      _WritingPage(tasks: _tasks, onUpdate: () => setState(() {})),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ThesisTrack SLR'),
        actions: [
          IconButton(
            tooltip: 'Review note',
            onPressed: () => _showReviewerNote(context),
            icon: const Icon(Icons.rate_review_outlined),
          ),
        ],
      ),
      body: pages[_pageIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _pageIndex,
        onDestinationSelected: (index) => setState(() => _pageIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.space_dashboard_outlined), label: 'Overview'),
          NavigationDestination(icon: Icon(Icons.library_books_outlined), label: 'Studies'),
          NavigationDestination(icon: Icon(Icons.account_tree_outlined), label: 'PRISMA'),
          NavigationDestination(icon: Icon(Icons.edit_note_outlined), label: 'Writing'),
        ],
      ),
    );
  }

  void _showReviewerNote(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reviewer-level reminder'),
        content: const Text('Before submission, verify that all study counts, PRISMA numbers, percentages, tables, and taxonomy labels are internally consistent.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }

  void _showAddStudySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, modalSetState) => Padding(
          padding: EdgeInsets.only(
            left: 18,
            right: 18,
            top: 18,
            bottom: MediaQuery.of(context).viewInsets.bottom + 18,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add study record', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Study title')),
              TextField(controller: _sourceController, decoration: const InputDecoration(labelText: 'Database / source')),
              TextField(controller: _yearController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Year')),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedModality,
                items: const [
                  DropdownMenuItem(value: 'Physiological', child: Text('Physiological')),
                  DropdownMenuItem(value: 'Facial', child: Text('Facial')),
                  DropdownMenuItem(value: 'Speech/Audio', child: Text('Speech/Audio')),
                  DropdownMenuItem(value: 'Text', child: Text('Text')),
                  DropdownMenuItem(value: 'Multimodal', child: Text('Multimodal')),
                ],
                onChanged: (value) => modalSetState(() => _selectedModality = value ?? 'Physiological'),
                decoration: const InputDecoration(labelText: 'Input modality'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedDecision,
                items: const [
                  DropdownMenuItem(value: 'Screening', child: Text('Screening')),
                  DropdownMenuItem(value: 'Included', child: Text('Included')),
                  DropdownMenuItem(value: 'Excluded', child: Text('Excluded')),
                ],
                onChanged: (value) => modalSetState(() => _selectedDecision = value ?? 'Screening'),
                decoration: const InputDecoration(labelText: 'Decision'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    final year = int.tryParse(_yearController.text.trim()) ?? DateTime.now().year;
                    if (_titleController.text.trim().isEmpty) return;
                    setState(() {
                      _studies.insert(
                        0,
                        StudyRecord(
                          title: _titleController.text.trim(),
                          source: _sourceController.text.trim().isEmpty ? 'Unknown' : _sourceController.text.trim(),
                          year: year,
                          modality: _selectedModality,
                          decision: _selectedDecision,
                        ),
                      );
                    });
                    _titleController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('Save study'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudyRecord {
  StudyRecord({required this.title, required this.source, required this.year, required this.modality, required this.decision});

  final String title;
  final String source;
  final int year;
  final String modality;
  final String decision;
}

class WritingTask {
  WritingTask({required this.section, required this.title, required this.done});

  final String section;
  final String title;
  bool done;
}

class _OverviewPage extends StatelessWidget {
  const _OverviewPage({required this.studies, required this.tasks});

  final List<StudyRecord> studies;
  final List<WritingTask> tasks;

  @override
  Widget build(BuildContext context) {
    final included = studies.where((study) => study.decision == 'Included').length;
    final excluded = studies.where((study) => study.decision == 'Excluded').length;
    final screening = studies.where((study) => study.decision == 'Screening').length;
    final doneTasks = tasks.where((task) => task.done).length;

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: const LinearGradient(colors: [Color(0xFF4A148C), Color(0xFF8E24AA)]),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.school_outlined, color: Colors.white, size: 38),
              SizedBox(height: 14),
              Text('Systematic Review Assistant', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
              SizedBox(height: 8),
              Text('Track screening decisions, PRISMA counts, modality taxonomy, and manuscript readiness.', style: TextStyle(color: Colors.white70, height: 1.5)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _MetricCard(title: 'Included', value: '$included', icon: Icons.check_circle_outline)),
            const SizedBox(width: 12),
            Expanded(child: _MetricCard(title: 'Excluded', value: '$excluded', icon: Icons.cancel_outlined)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _MetricCard(title: 'Screening', value: '$screening', icon: Icons.filter_alt_outlined)),
            const SizedBox(width: 12),
            Expanded(child: _MetricCard(title: 'Writing', value: '$doneTasks/${tasks.length}', icon: Icons.edit_note_outlined)),
          ],
        ),
        const SizedBox(height: 18),
        const Text('Taxonomy snapshot', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        _TaxonomyCard(studies: studies),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.title, required this.value, required this.icon});

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 14),
            Text(value, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
            Text(title, style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class _TaxonomyCard extends StatelessWidget {
  const _TaxonomyCard({required this.studies});

  final List<StudyRecord> studies;

  @override
  Widget build(BuildContext context) {
    final modalities = ['Physiological', 'Facial', 'Speech/Audio', 'Text', 'Multimodal'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: modalities.map((modality) {
            final count = studies.where((study) => study.modality == modality).length;
            final ratio = studies.isEmpty ? 0.0 : count / studies.length;
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(modality, style: const TextStyle(fontWeight: FontWeight.w800))),
                      Text('$count'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(value: ratio),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _StudiesPage extends StatelessWidget {
  const _StudiesPage({required this.studies, required this.onAddStudy});

  final List<StudyRecord> studies;
  final VoidCallback onAddStudy;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onAddStudy,
        icon: const Icon(Icons.add),
        label: const Text('Study'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text('Study Records', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          ...studies.map((study) => _StudyTile(study: study)),
        ],
      ),
    );
  }
}

class _StudyTile extends StatelessWidget {
  const _StudyTile({required this.study});

  final StudyRecord study;

  @override
  Widget build(BuildContext context) {
    final color = switch (study.decision) {
      'Included' => Colors.green,
      'Excluded' => Colors.red,
      _ => Colors.orange,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(study.title, style: const TextStyle(fontWeight: FontWeight.w900))),
                Chip(
                  label: Text(study.decision),
                  backgroundColor: color.withOpacity(.12),
                  labelStyle: TextStyle(color: color, fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('${study.source} • ${study.year} • ${study.modality}', style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class _PrismaPage extends StatelessWidget {
  const _PrismaPage({required this.studies});

  final List<StudyRecord> studies;

  @override
  Widget build(BuildContext context) {
    final identified = studies.length + 8;
    final screened = studies.length;
    final excluded = studies.where((study) => study.decision == 'Excluded').length;
    final included = studies.where((study) => study.decision == 'Included').length;

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text('PRISMA Counter', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        const Text('A simplified numerical flow for systematic review screening.'),
        const SizedBox(height: 16),
        _PrismaStep(title: 'Records identified', value: identified, icon: Icons.search_outlined),
        _PrismaArrow(),
        _PrismaStep(title: 'Records screened', value: screened, icon: Icons.rule_outlined),
        _PrismaArrow(),
        _PrismaStep(title: 'Records excluded', value: excluded, icon: Icons.remove_circle_outline),
        _PrismaArrow(),
        _PrismaStep(title: 'Studies included', value: included, icon: Icons.task_alt_outlined),
        const SizedBox(height: 16),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Text('Reviewer warning: PRISMA numbers must match the Methods, Results, tables, figures, and appendices before submission.'),
          ),
        ),
      ],
    );
  }
}

class _PrismaStep extends StatelessWidget {
  const _PrismaStep({required this.title, required this.value, required this.icon});

  final String title;
  final int value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        trailing: Text('$value', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
      ),
    );
  }
}

class _PrismaArrow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Center(child: Icon(Icons.keyboard_arrow_down, size: 34)),
    );
  }
}

class _WritingPage extends StatelessWidget {
  const _WritingPage({required this.tasks, required this.onUpdate});

  final List<WritingTask> tasks;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text('Manuscript Checklist', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        const Text('A writing checklist designed for systematic review quality control.'),
        const SizedBox(height: 14),
        ...tasks.map(
          (task) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: CheckboxListTile(
              value: task.done,
              onChanged: (value) {
                task.done = value ?? false;
                onUpdate();
              },
              title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.w800)),
              subtitle: Text(task.section),
            ),
          ),
        ),
      ],
    );
  }
}
