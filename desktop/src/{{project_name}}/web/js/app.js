function app() {
  const readies = [];
  const parts = PARTS.map((factory) => {
    const part = factory();
    if (part.ready) readies.push(part.ready);
    delete part.ready;
    return part;
  });

  return mix(
    {
      ready: false,
      tab: 'home',
      defaultTheme: document.documentElement.dataset.theme,
      theme: document.documentElement.dataset.theme,
      toasts: [],

      get themes() {
        return [this.defaultTheme, ...THEMES];
      },

      async init() {
        await pywebviewReady();
        const prefs = await this.call('get_prefs');
        this.theme = prefs.theme ?? this.defaultTheme;
        document.documentElement.dataset.theme = this.theme;
        this.$watch('theme', (theme) => {
          document.documentElement.dataset.theme = theme;
          this.call('set_pref', 'theme', theme);
        });
        for (const ready of readies) await ready.call(this);
        this.ready = true;
      },

      async call(method, ...args) {
        try {
          return await window.pywebview.api[method](...args);
        } catch (e) {
          if (e?.name === 'ValueError') {
            this.toast(e.message, 'error');
          } else {
            console.error(`${method} failed:`, e);
            this.toast('Something went wrong. The details are in the log.', 'error');
          }
          throw e;
        }
      },

      toast(message, type = 'success') {
        const t = { id: Date.now() + Math.random(), message, type };
        this.toasts.push(t);
        setTimeout(() => (this.toasts = this.toasts.filter((x) => x.id !== t.id)), type === 'error' ? 6000 : 3500);
      },

      openModal(name) {
        this.$refs[`${name}Modal`].showModal();
      },

      closeModal(name) {
        this.$refs[`${name}Modal`].close();
      },
    },
    ...parts,
  );
}
