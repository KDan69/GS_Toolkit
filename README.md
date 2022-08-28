# GS Toolkit
Sada nástrojů pro Aegisub
## O skriptu
Původní skript (TeamNS Toolkit) sloužil k usnadnění vkládání loga a stylů nebo např. ke znepříjemnění dne sledovačů pochybných online streamů. Byl dostupný pouze členům skupiny a pár výjimkám, ale jeho upravenou a aktuální verzi nyní najdete zde.
### Co to teď vůbec umí?
- Generovat výpisy změn pro usnadnění korektury
- Načíst druhé titulky a porovnávat mezi nimi a momentálně upravovanými
- Rychleji upravovat údaje ve vlastnostech souboru 

### Co už neumí?
- Vkládat TeamNS logo
- Vkládat skryté zprávy do výše uvedeného loga
- Znepříjemnit den sledovačům pochybných online streamů
  - Možná ale později bude opět umět, momentálně je rozpracovaná velice účinná varianta, nicméně kvůli nedostatku času jsem se soustředil na jiné věci
- Způsobovat chyby při spouštění pod Windows XP ^_^

## Instalace
Skript stačí umístit do složky `automation\autoload`, která je ve složce s Aegisubem (např. `C:\Program Files\Aegisub`).

Pro využití porovnávací funkce, resp. importu titulků z videa, je potřeba nainstalovat [MKVToolNix](https://www.fosshub.com/MKVToolNix.html), Aegisub to sice sám od sebe umí, ale tato funkce se bohužel nedá spustit pomocí skriptu.

## Dokončení
Po spuštění Aegisubu by nyní měl v kartě Automation přibýt GS Toolkit. Probliknutí příkazovéno řádku při spouštění je normální, slouží k přidělení práv k zápisu do pracovní složky (`Dokumenty\GS Toolkit`).

Doporučuji pro funkce zápisu změny a porovnání nastavit klávesové zkratky (osobně používám klávesy F6 a F7).
