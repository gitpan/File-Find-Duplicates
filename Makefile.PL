use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'		=> 'File::Find::Duplicates',
    'VERSION_FROM'	=> 'Duplicates.pm', 
    'PREREQ_PM'		=> { 
                              File::Temp => 0.12,
                              Digest::MD5 => 2.0,
                              Test::Simple => 0.02,
                           }, 
    ($] < 5.005 ? () : 
      (ABSTRACT_FROM => 'Duplicates.pm', # retrieve abstract from module
       AUTHOR     => 'Tony Bowden <kasei@tmtm.com>') 
    ),
);
