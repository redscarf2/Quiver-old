sub CreateFile
{
	local( $Filename ) = shift;
	local( *FILE );

	open FILE, ">$Filename";
	close FILE;
}

sub ProcessFile
{
	local( $Filename ) = shift;
	local( @fileContents );
#	print "$Filename\n";
	if( $Filename =~ /\.vtf/i )
	{
		return if( $Filename =~ /_normal/i );
		return if( $Filename =~ /_dudv/i );
		local( $cmd ) = "..\\..\\..\\bin\\vtfscrew \"$Filename\" $r $g $b";
		print $cmd . "\n";
		system $cmd;
	}
}

sub ProcessFileOrDirectory
{
	local( $name ) = shift;

#	If the file has "." at the end, skip it.
	if( $name eq "." || $name eq ".." || $name =~ /\.$/ )
	{
#		print "skipping: $name\n";
		return;
	}

#   Figure out if it's a file or a directory.
	if( -d $name )
	{
		local( *SRCDIR );
#		print "$name is a directory\n";
		opendir SRCDIR, $name;
		local( @dir ) = readdir SRCDIR;
		closedir SRCDIR;

		local( $item );
		while( $item = shift @dir )
		{
			&ProcessFileOrDirectory( $name . "/" . $item );
		}
	}
	elsif( -f $name )
	{
		&ProcessFile( $name );
	}
	else
	{
		print "$name is neither a file or a directory\n";
	}
	return;
}

$baseDirectory		= shift;
$r = shift;
$g = shift;
$b = shift;

if( !$baseDirectory )
{
	die "Usage: createvmt.pl baseDir";
}

print "baseDirectory = \"$baseDirectory\"\n";

opendir SRCDIR, $baseDirectory;
@dir = readdir SRCDIR;
closedir SRCDIR;

while( $item = shift @dir )
{
	&ProcessFileOrDirectory( "$baseDirectory/$item" );
}


