const core = require('@actions/core');
const inputs = require('./inputs.json');
const outputs = require('./outputs.json');
const util = require('util');
const path = require('path');


const exec = util.promisify(require('child_process').exec);

const handleDryRunOption = function() {
    const dryRun = core.getInput(inputs.dry_run);
    
    switch (dryRun) {
        case 'true':
            return {dryRun: true};
            
            case 'false':
                return {dryRun: false};
                
                default:
                    return {};
                }
};

const preInstall = async function(extras) {
    if (!extras) {
      return Promise.resolve();
    }
    const _extras = extras.replace(/['"]/g, '').replace(/[\n\r]/g, ' ');
  
    const { stdout, stderr } = await exec(`npm install --no-package-lock --legacy-peer-deps --save false @semantic-release/changelog @semantic-release/git @semantic-release/exec ${_extras} --silent`, {
      cwd: path.resolve(__dirname, '..')
    });
    core.debug(stdout);
    core.error(stderr);
};

const setUpJob = async function() {
    // set outputs default
    core.setOutput(outputs.new_release_published, 'false');
  
    core.debug('action_workspace: ' + path.resolve(__dirname, '..'));
    core.debug('process.cwd: ' + process.cwd());
  
    return Promise.resolve();
};

const cleanupNpmrc = async function() {
    const {stdout, stderr} = await exec(`rm -f .npmrc`);
    core.debug(stdout);
  
    if (stderr) {
      return Promise.reject(stderr);
    }
};

const windUpJob = async function(result) {
    if (!result) {
        core.debug('No release published.');
        return Promise.resolve();
    }

    const {lastRelease, commits, nextRelease, releases} = result;

    if (lastRelease.version) {
        core.debug(`The last release was "${lastRelease.version}".`);
        core.setOutput(outputs.last_release_version, lastRelease.version)
    }

    if (!nextRelease) {
        core.debug('No release published.');
        return Promise.resolve();
    }

    core.debug(`Published ${nextRelease.type} release version ${nextRelease.version} containing ${commits.length} commits.`);

    for (const release of releases) {
        core.debug(`The release was published with plugin "${release.pluginName}".`);
    }

    const {version, channel, notes, gitHead, gitTag} = nextRelease;
    const [major, minor, patch] = version.split(/\.|-|\s/g, 3);

    // set outputs
    core.setOutput(outputs.new_release_published, 'true');
    core.setOutput(outputs.new_release_version, version);
    core.setOutput(outputs.new_release_major_version, major);
    core.setOutput(outputs.new_release_minor_version, minor);
    core.setOutput(outputs.new_release_patch_version, patch);
    core.setOutput(outputs.new_release_channel, channel);
    core.setOutput(outputs.new_release_notes, notes);  
    core.setOutput(outputs.new_release_git_head, gitHead);
    core.setOutput(outputs.new_release_git_tag, gitTag);
    core.setOutput(outputs.last_release_version, lastRelease.version);
    core.setOutput(outputs.last_release_git_head, lastRelease.gitHead);
    core.setOutput(outputs.last_release_git_tag, lastRelease.gitTag);
};

const release = async function() {
    try {
        core.debug('Initialization successful');
        if (core.getInput(inputs.working_directory)) {
        process.chdir(core.getInput(inputs.working_directory));
        }
        await setUpJob();
        await preInstall(core.getInput(inputs.extra_plugins));
    
        const semanticRelease = require('semantic-release');
        const result = await semanticRelease(handleDryRunOption());
    
        await cleanupNpmrc();
        await windUpJob(result);
        }
        catch(err) {
            core.setFailed;
        }
};
  
  module.exports = function() {
    core.debug('Initialization successful');
    release().catch(core.setFailed);
};

const run = async function() {
    // Install Dependencies
    {
      const {stdout, stderr} = await exec('npm --loglevel error ci --only=prod', {
        cwd: path.resolve(__dirname)
      });
      console.log(stdout);
      if (stderr) {
        console.log(stderr);
        if (stderr != "Debugger attached.\nWaiting for the debugger to disconnect...\n"){
            return Promise.reject(stderr);
        }
      }
    }
  
    release();
};
  
run().catch(console.error);