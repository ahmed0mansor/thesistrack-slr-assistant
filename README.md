# ThesisTrack SLR

A Flutter application for **systematic review tracking**, designed for research students and academic authors.

## Value

This project demonstrates:

- Flutter productivity app design
- Study screening workflow
- PRISMA-style numerical tracking
- Modality taxonomy visualization
- Manuscript checklist logic
- Academic portfolio relevance

## Screens

- Overview
- Study Records
- PRISMA Counter
- Manuscript Checklist

## Run

```bash
flutter pub get
flutter run -d chrome
```

To generate native Android/iOS platform folders:

```bash
flutter create . --platforms=android,ios,web
flutter run
```

## Future Improvements

- CSV import/export
- SQLite local database
- Search filters
- Bibliography manager
- PDF report generator
