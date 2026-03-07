const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const LOVE_GAMES_DIR = path.resolve(__dirname, '../love-games');
const OUTPUT_DIR = path.resolve(__dirname, '../public/games');

function slugToDisplayName(slug) {
  return slug
    .replace(/_/g, ' ')
    .replace(/([A-Z])/g, ' $1')
    .trim()
    .replace(/\s+/g, ' ')
    .split(' ')
    .map((w) => w.charAt(0).toUpperCase() + w.slice(1).toLowerCase())
    .join(' ');
}

function discoverGames() {
  const entries = fs.readdirSync(LOVE_GAMES_DIR, { withFileTypes: true });
  const games = [];
  for (const entry of entries) {
    if (!entry.isDirectory()) continue;
    const mainLua = path.join(LOVE_GAMES_DIR, entry.name, 'main.lua');
    if (fs.existsSync(mainLua)) {
      games.push({
        slug: entry.name,
        name: slugToDisplayName(entry.name),
      });
    }
  }
  return games;
}

function buildGames() {
  fs.mkdirSync(OUTPUT_DIR, { recursive: true });
  const games = discoverGames();
  const manifest = [];

  for (const game of games) {
    const inputPath = path.join(LOVE_GAMES_DIR, game.slug);
    const outputPath = path.join(OUTPUT_DIR, game.slug);
    console.log(`Building ${game.name}...`);
    execSync(
      `npx love.js -t "${game.name}" -c "${inputPath}" "${outputPath}"`,
      { stdio: 'inherit', cwd: path.resolve(__dirname, '..') }
    );
    manifest.push({ slug: game.slug, name: game.name });
  }

  fs.writeFileSync(
    path.join(OUTPUT_DIR, 'games.json'),
    JSON.stringify(manifest, null, 2)
  );
  console.log(`Built ${manifest.length} games.`);
}

buildGames();
