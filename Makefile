VERSION = 0.43
RELEASE = 0
PREFIX = /usr
INSTALLDIR = $(PREFIX)/lib/xdobry
BINDIR = $(PREFIX)/bin
OPTDIR = /opt/xdobry
NAME=xdobry


IDE_FILES=ideBgError.tcl IDEErrorReporter.xotcl IDEBaseGUI.xotcl
# ab version 0.22 IDE are not part of xdobry

XDFILES=FormEditor.tcl SchemaEditor.tcl FormServer.tcl Init.tcl CHANGES LICENSE README xdobry.lsm KeyedList.xotcl createtables.xsl base64.xotcl

dist:
	mkdir ${NAME}-${VERSION}
	mkdir -p ${NAME}-${VERSION}/docs/docu
	mkdir ${NAME}-${VERSION}/docs/docu_en
	mkdir ${NAME}-${VERSION}/sample
	mkdir ${NAME}-${VERSION}/dtd
	mkdir ${NAME}-${VERSION}/bitmaps
	cp xd_docs/docu/*.html ${NAME}-${VERSION}/docs/docu
	cp xd_docs/*.png ${NAME}-${VERSION}/docs/
	cp xd_docs/docu_en/*.html ${NAME}-${VERSION}/docs/docu_en
	cp xd_docs/*.sgml ${NAME}-${VERSION}/docs
	cp DMakefile ${NAME}-${VERSION}/Makefile
	cp LICENSE xdobry_*.xotcl ${XDFILES} ${IDE_FILES} \
           *.msg validate.sh ${NAME}-${VERSION}
	cp sample/kurs* sample/uni* sample/business* sample/accountancy* \
	    ${NAME}-${VERSION}/sample
	cp dtd/*.dtd ${NAME}-${VERSION}/dtd
	cp bitmaps/*.gif ${NAME}-${VERSION}/bitmaps
	cd ${NAME}-${VERSION} ; echo "pkg_mkIndex -direct . *.xotcl" | tclsh 
	tar -cvzf ${NAME}-${VERSION}-${RELEASE}.tar.gz ${NAME}-${VERSION}
	rm -f -r ${NAME}-${VERSION}
install:
	install -d $(INSTALLDIR)/sample
	install -d $(INSTALLDIR)/dtd
	install -d $(INSTALLDIR)/bitmaps
	install -m 0644 sample/* $(INSTALLDIR)/sample
	install -m 0644 dtd/* $(INSTALLDIR)/dtd
	install -m 0644 bitmaps/* $(INSTALLDIR)/bitmaps
	install -m 0644 *.lan *.xotcl *.tcl $(INSTALLDIR)
	install SchemaEditor.tcl FormEditor.tcl FormServer.tcl validate.sh $(INSTALLDIR)
	ln -s ../lib/xdobry/SchemaEditor.tcl $(BINDIR)/SchemaEditor
	ln -s ../lib/xdobry/FormEditor.tcl $(BINDIR)/FormEditor
	ln -s ../lib/xdobry/FormServer.tcl $(BINDIR)/FormServer

uninstall:
	rm -r -f $(INSTALLDIR)

install2opt:
	install -d $(OPTDIR)/lib/xdobry/sample
	install -d $(OPTDIR)/lib/xdobry/dtd
	install -d $(OPTDIR)/lib/xdobry/bitmaps
	install -m 0644 sample/kurs* $(OPTDIR)/lib/xdobry/sample
	install -m 0644 sample/business* $(OPTDIR)/lib/xdobry/sample
	install -m 0644 sample/uni* $(OPTDIR)/lib/xdobry/sample
	install -m 0644 sample/accountancy* $(OPTDIR)/lib/xdobry/sample
	install -m 0644 sample/xotcllib* $(OPTDIR)/lib/xdobry/sample
	install -m 0644 dtd/*.dtd $(OPTDIR)/lib/xdobry/dtd
	install -m 0644 bitmaps/*.gif $(OPTDIR)/lib/xdobry/bitmaps
	install -m 0644 *.lan xdobry_*.xotcl $(OPTDIR)/lib/xdobry
	install -m 0644 IDEErrorReporter.xotcl ideBgError.tcl $(OPTDIR)/lib/xdobry
	install -m 0644 Init.tcl $(OPTDIR)/lib/xdobry
	cd $(OPTDIR)/lib/xdobry ; echo "pkg_mkIndex -direct . *.xotcl" | tclsh
	echo "Warning Startfiles in bin are not copied"
	#install SchemaEditor.tcl FormEditor.tcl FormServer.tcl validate.sh $(OPTDIR)/lib/xdobry
samples:
	tar cvzf samples.tar.gz sample/accountancy.* sample/business.* sample/uni.* sample/*.eps sample/*.dia
