CALL_MAKE = $(MAKE) --no-print-directory

all: 
	@$(CALL_MAKE) PROJ=zx81 make_proj
	@$(CALL_MAKE) PROJ=tk85 make_proj
	@$(CALL_MAKE) PROJ=sg81 make_proj

clean: 
	@$(CALL_MAKE) PROJ=zx81 clean_proj
	@$(CALL_MAKE) PROJ=tk85 clean_proj
	@$(CALL_MAKE) PROJ=sg81 clean_proj

make_proj: $(PROJ).bin $(PROJ).html

$(PROJ).bin: $(PROJ).asm
	z80asm -b -l -m $(PROJ).asm 
	dz80c -q $(PROJ).bin $(PROJ).dump
	dz80c -q $(PROJ).rom $(PROJ).rom.dump
	diff -I '^;' $(PROJ).dump $(PROJ).rom.dump
	rm $(PROJ).rom.dump

$(PROJ).asm: $(wildcard src/*.asm)
	perl -S filepp -DROM_$(PROJ) src/zx81_roms.asm -o $(PROJ).asm

clean_proj:
	rm -f $(PROJ).bin $(PROJ).err $(PROJ).i $(PROJ).o $(PROJ).lis $(PROJ).map $(PROJ)*.dump *.bak

$(PROJ).html: $(PROJ).asm format_asm.pl build_asm_html.pl
	perl format_asm.pl     $(PROJ).asm
	perl build_asm_html.pl $(PROJ).asm
