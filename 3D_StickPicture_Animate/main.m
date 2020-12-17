
time = (0:1e-2:2*pi)';

x = [cos(time), 2 * cos(time)];
y = [sin(time), sin(time)];
z = [time, time] / time(end);

Anime_Fig = Anime(time, x, y, z);
xlim(Anime_Fig.axAnime, [min(x(:)), max(x(:))])
ylim(Anime_Fig.axAnime, [min(y(:)), max(y(:))])
zlim(Anime_Fig.axAnime, [min(z(:)), max(z(:))])
grid(Anime_Fig.axAnime, 'on')