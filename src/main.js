const list = document.getElementById('games');

fetch('/games/games.json')
  .then((r) => r.json())
  .then((games) => {
    for (const { slug, name } of games) {
      const li = document.createElement('li');
      const a = document.createElement('a');
      a.href = `/games/${slug}/index.html`;
      a.textContent = name;
      li.appendChild(a);
      list.appendChild(li);
    }
  })
  .catch((err) => {
    list.innerHTML = '<li>Failed to load games.</li>';
    console.error(err);
  });
