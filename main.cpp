#include <mapnik/map.hpp>
#include <mapnik/load_map.hpp>
#include <mapnik/agg_renderer.hpp>

// https://github.com/mapnik/mapnik/wiki/PostGIS
// https://github.com/mapnik/mapnik/wiki/OptimizeRenderingWithPostGIS

class RenderServer {
  mapnik::Map m_Map;

 public:
  RenderServer(int32_t i_i32Width, int32_t i_i32Height): m_Map(i_i32Width, i_i32Height) {};
};

struct Configuration {
  const char* m_sStyleSheet = nullptr;

  static void printHelp() {
    printf("usage: ./mapnik_server {arguments}\n"
           "\t-s\t--stylesheet\tpath to the xml stylesheet\n"
           "\t-h\t--help\t\t\tprint this help text\n");
  }

  static Configuration parse(int argc, char** argv) {
    Configuration cfg {};
    for(uint32_t i = 0; i < argc; i++) {
      if(!strcmp(argv[i], "-s") || !strcmp(argv[i], "--stylesheet")) {
        cfg.m_sStyleSheet = argv[i + 1];
      } else if(!strcmp(argv[i], "-h") || !strcmp(argv[i], "--help")) {
        printHelp();
      }
    }
    return cfg;
  }

  [[nodiscard]] bool isOk() const {
    return m_sStyleSheet != nullptr;
  }
};


int main(int argc, char** argv) {
  printf("Going to parse arguments\n");
  auto cfg = Configuration::parse(argc, argv);

  if(!cfg.isOk()) {
    printf("Configuration is not ok, please consult the -h / --help parameter.\n");
    return 0;
  } else {
    printf("Configuration is ok, starting server.\n");
  }

  return 0;
}
