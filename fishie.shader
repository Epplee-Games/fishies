shader_type particles;

float rand_from_seed(in uint seed) {
  int k;
  int s = int(seed);
  if (s == 0)
    s = 305420679;
  k = s / 127773;
  s = 16807 * (s - k * 127773) - 2836 * k;
  if (s < 0)
    s += 2147483647;
  seed = uint(s);
  return float(seed % uint(65536)) / 65535.0;
}

uint hash(uint x) {
  x = ((x >> uint(16)) ^ x) * uint(73244475);
  x = ((x >> uint(16)) ^ x) * uint(73244475);
  x = (x >> uint(16)) ^ x;
  return x;
}

void vertex() {
	if (RESTART) {
		uint alt_seed1 = hash(NUMBER + uint(1) + RANDOM_SEED);
		uint alt_seed2 = hash(NUMBER + uint(27) + RANDOM_SEED);
		uint alt_seed3 = hash(NUMBER + uint(43) + RANDOM_SEED);
		uint alt_seed4 = hash(NUMBER + uint(111) + RANDOM_SEED);
		
		CUSTOM.x = rand_from_seed(alt_seed1);
		float rand_x = rand_from_seed(alt_seed2) * 8.0;
		vec2 position = vec2(rand_x, sin(rand_x));

		TRANSFORM[3].xy = position * 20.0;
		VELOCITY.y = 10.0;
	}
}
