# GS Toolkit
Sada nástrojů pro Aegisub
## O skriptu
Původní skript (TeamNS Toolkit) sloužil k usnadnění vkládání loga a stylů nebo např. ke znepříjemnění dne sledovačů pochybných online streamů. Byl dostupný pouze členům skupiny a pár výjimkám, ale jeho upravenou a aktuální verzi nyní najdete zde.
### Co to vůbec umí?
- Generovat výpisy změn pro usnadnění korektury
- Načíst druhé titulky a porovnávat mezi nimi a momentálně upravovanými
- Rychleji upravovat údaje ve vlastnostech souboru
- Exportovat titulky s dvojí transkripcí

### Co to dřív umělo, ale už neumí?
- Vkládat TeamNS logo
- Vkládat skryté zprávy do výše uvedeného loga
- Znepříjemnit den sledovačům pochybných online streamů
  - Možná ale později bude opět umět, momentálně je rozpracovaná velice účinná varianta, nicméně kvůli nedostatku času jsem se soustředil na jiné věci
- Způsobovat chyby při spouštění pod Windows XP ^_^

## Instalace
Skript stačí umístit do složky `automation\autoload`, která je ve složce s Aegisubem (např. `C:\Program Files\Aegisub`, v případě Linuxu `/usr/share/aegisub`).

Pro využití porovnávací funkce, resp. importu titulků z videa, je potřeba nainstalovat [MKVToolNix](https://www.fosshub.com/MKVToolNix.html), Aegisub to sice sám od sebe umí, ale tato funkce se bohužel nedá spustit pomocí skriptu. Tato funkce zatím **nefunguje pod Linuxem**.

## Dokončení
Po spuštění Aegisubu by nyní měl v kartě Automation přibýt GS Toolkit. Probliknutí příkazovéno řádku při spouštění je normální, slouží k přidělení práv k zápisu do pracovní složky (Windows: `Dokumenty\GS Toolkit`, Linux: `usr/home/[uživatel]/.gstoolkit`).

## Doporučené nastavení klávesových zkratek
- Zápis změny - F6
- Porovnávač titulků - F7
- Převést na \trans tag - F8

# Použití dvojí transkripce
Funkce je experimentální - **používat na vlastní nebezpečí!**
### Výhody
- možnost výběru
- nikdo nemůže kňučet, že je v titulkách "Curuja" místo "Tsuruya"
### Nevýhody
- je s tím víc práce
- při úpravě se stávají dvojí názvy v náhledu nečitelné - tuto funkci je vhodné použít spíše během korektury
## Příprava titulků
Do titulků je logicky potřeba psát dvě varianty názvů. Názvy se jednoduše napíšou za sebe s transkripčním separátorem (výchozí je ";", dá se změnit v nastavení) a následně se příkazem "Převést na \trans tag" zpracují. Takto zpracované titulky je poté nutno exportovat se zvolenou transkripcí (File -> Export subtitles...)
### Příklad
- Původní věta: "Koishi si jde pro rybářský prut."
- Krok 1: "Koishi;Koiši si jde pro rybářský prut."
- Krok 2: "{\trans("Koishi", "Koiši")} si jde pro rybářský prut."

Poznámka: na první pozici je vždy anglická transkripce, na druhé česká
## Bacha na čárky!
Pokud není název oddělen pouze mezerami, ale končí například čárkou, je nutno ji psát dvakrát! (tohle se pokusím časem opravit, ale debilní lua regex mi to moc nezlehčuje...)
### Příklad
- Původní věta: "Shinji, ty blboune!"
### Špatný postup
- Krok 1: "Shinji;Šindži, ty blboune!"
- Krok 2: "{\trans("Shinji", "Šindži,")} ty blboune!" 
### Správný postup
- Krok 1: "Shinji,;Šindži, ty blboune!"
- Krok 2: "{\trans("Shinji,", "Šindži,")} ty blboune!"
