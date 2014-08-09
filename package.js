Package.describe({
  summary: " \* Fill me in! *\ ",
  version: "1.0.0",
  git: " \* Fill me in! *\ "
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR-CORE@0.9.0-rc5');
  api.addFiles('bads:doc-ctrl.js');
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('bads:doc-ctrl');
  api.addFiles('bads:doc-ctrl-tests.js');
});
