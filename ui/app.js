const { createApp } = Vue;

createApp({
  data() {
    return {
      message: "",
      visible: false,
      theme: null,
      time: 0,
      currenttime: 0,
      interval: null,
      timeout: null,
      running: false,
      maincolor: null,
      width: '20vw'
    };
  },
  mounted() {
    window.addEventListener("message", this.onMessage);
    // Add ESC key listener
    window.addEventListener("keydown", (e) => {
      if (e.key === "Escape") {
        this.cancel(); // Trigger cancel if ESC is pressed
      }
    });
  },
  destroyed() {
    window.removeEventListener("message", this.onMessage);
    if (this.interval) clearInterval(this.interval);
    if (this.timeout) clearTimeout(this.timeout);
  },
  computed: {
    counter() {
      return Math.trunc((this.time - (this.currenttime)) / 1000)
    }
  },
  methods: {
    onMessage(event) {
      if (event.data.type === "open") {
        if (this.running) return;
        this.visible = true;
        this.message = event.data.message;
        this.theme = event.data.theme;
        this.time = event.data.mili;
        this.maincolor = event.data.color;
        this.width = event.data.width;
  
        this.running = true;
  
        this.interval = setInterval(() => {
          this.currenttime += 1000;
        }, 1000);
  
        this.timeout = setTimeout(() => {
          this.running = false;
          this.visible = false;
          clearInterval(this.interval);
          this.currenttime = 0;
          this.interval = null;
          this.timeout = null;
  
          fetch(`https://${GetParentResourceName()}/Feather:Prog:Finish`, {
            method: "POST"
          });
        }, event.data.mili);
      }
  
      if (event.data.type === "cancel") {
        this.running = false;
        this.visible = false;
        clearInterval(this.interval);
        clearTimeout(this.timeout);
        this.currenttime = 0;
        this.interval = null;
        this.timeout = null;
      }
    },
    cancel() {
      this.running = false;
      this.visible = false;
      clearInterval(this.interval);
      clearTimeout(this.timeout);
      this.currenttime = 0;
      this.interval = null;
      this.timeout = null;
  
      fetch(`https://${GetParentResourceName()}/Feather:Prog:Cancel`, {
        method: "POST"
      });
    }
  }
}).mount("#app");
