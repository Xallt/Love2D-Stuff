const list = document.getElementById('games');
const base = import.meta.env.BASE_URL;

fetch(`${base}games/games.json`)
  .then((r) => r.json())
  .then((games) => {
    for (const { slug, name } of games) {
      const li = document.createElement('li');
      const a = document.createElement('a');
      a.href = `${base}games/${slug}/index.html`;
      a.textContent = name;
      li.appendChild(a);
      list.appendChild(li);
    }
  })
  .catch((err) => {
    list.innerHTML = '<li>Failed to load games.</li>';
    console.error(err);
  });
