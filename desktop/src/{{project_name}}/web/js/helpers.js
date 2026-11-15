const THEMES = ['dark', 'night', 'dim', 'light', 'nord', 'cupcake', 'emerald', 'corporate'];

// Each tab registers its state and methods, and app.js mixes them into one component
const PARTS = [];

function registerPart(factory) {
  PARTS.push(factory);
}

function pywebviewReady() {
  return new Promise((resolve) => {
    if (window.pywebview?.api) resolve();
    else window.addEventListener('pywebviewready', resolve, { once: true });
  });
}

// Like Object.assign, but keeps getters as getters
function mix(...parts) {
  return parts.reduce((target, part) => Object.defineProperties(target, Object.getOwnPropertyDescriptors(part)), {});
}
