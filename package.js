Package.describe({
  summary: " Provide Document Transform on local Collection",
  version: "1.0.0",
  git: "",
  name: "bads:doc-ctrl"
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@0.9.2-rc1');
  api.use([
    'coffeescript',
    "spacebars-compiler",
    'accounts-base',
    'standard-app-packages'
  ]);
  api.addFiles('doc-ctrl.coffee', 'client');
  api.export([
    'DCtl'
  ]);
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('bads:doc-ctrl');
  api.addFiles('bads:doc-ctrl-tests.js');
});
