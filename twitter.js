new TWTR.Widget({
    version: 2,
    type: 'list',
    rpp: 5,
    interval: 6000,
    title: '',
    subject: 'Team Shoes on Twitter',
    width: 400,
    height: 400,
    theme: {
      shell: {
        background: '#ffffff',
        color: '#000000'
      },
      tweets: {
        background: '#ffffff',
        color: '#444444',
        links: '#054a00'
      }
    },
    features: {
      scrollbar: false,
      loop: false,
      live: false,
      hashtags: true,
      timestamp: true,
      avatars: true,
      behavior: 'all'
    }
  }).render().setList('hasmanytweets', 'shooooooes').start();

