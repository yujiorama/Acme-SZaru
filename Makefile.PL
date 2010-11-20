use 5.010001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Acme::SZaru',
    VERSION_FROM      => 'lib/Acme/SZaru.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Acme/SZaru.pm', # retrieve abstract from module
       AUTHOR         => 'Yuji Okazawa <yujiorama@gmail.com>') : ()),
    LIBS              => ['-L/usr/local/lib -lszaru'], # e.g., '-lm'
    DEFINE            => '', # e.g., '-DHAVE_SOMETHING'
    INC               => '-I. -I/usr/local/include', # e.g., '-I. -I/usr/include/other'
	# Un-comment this if you add C files to link with later:
    # OBJECT            => '$(O_FILES)', # link all the C files too
    CC => 'g++',
    LD => 'g++',
    XSOPT => '-C++',
    TYPEMAPS => ['lib/Acme/typemap'],
);
