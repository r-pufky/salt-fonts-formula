{%- from "fonts/map.jinja" import fonts, config with context -%}

install_font_config:
  pkg.latest:
    - pkgs:
{%- for pkg in fonts.package_dependencies %}
      - {{ pkg }}
{%- endfor %}

copy_fonts:
  file.recurse:
    - name: {{ config.get('linux', fonts.linux) }}
    - source: 'salt://fonts/files/fonts'
    - dir_mode: 0755
    - file_mode: 0644
    - user: root
    - group: staff

refresh_font_cache:
  cmd.run:
    - name: {{ config.get('linux_refresh', fonts.linux_refresh) }}
    - hide_output: True
    - require:
      - pkg: install_font_config
    - onchanges:
      - file: copy_fonts
