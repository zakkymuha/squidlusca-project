#!/usr/bin/perl
# update 24 November 2013
# for ALL Youtube ( range & non range ) + 4shared
# storeurl dari tempat sampah
# send link from youtube contain >> (ptracking|stream_204|player_204|gen_204) to storeurl

$|=1;
while (<>) {
    @X = split;
       $x = $X[0] . " ";
       $_ = $X[1];
       $u = $X[1];

        #facebook
if (m/^http\:\/\/.*(profile|photo).*\.ak\.fbcdn\.net(\/h(profile|photos)-ak-)(snc|ash|prn)[0-9]?(.*)/) {
        print $x . "http://facebook.SQUIDINTERNAL" . $2  . "fb" .  $5  . "\n";
        
        # FACEBOOK VIDEO
} elsif (m/^http:\/\/(video\.ak\.fbcdn\.net)\/(.*?)\/(.*\.mp4)\??.*$/) {
print $x . "http://" . $1 . "/" . $3 . "";
} elsif (m/^http:\/\/video\.(.*)\.fbcdn\.net\/(.*?)\/([0-9_]+\.(mp4|flv|avi|mkv|m4v|mov|wmv|3gp|mpg|mpeg)?)(.*)/) {
print $x . "http://video.ak.fbcdn.net/" . $3 . "";


        #Speedtest
} elsif (m/^http\:\/\/.*\/speedtest\/(.*)\?.*/) {
        print $x . "http://speedtest.SQUIDINTERNAL/speedtest/" . $1 . "\n";
        
        #reverbnation
} elsif (m/^http:\/\/[a-z0-9]{4}\.reverbnation\.com\/.*\/([0-9]*).*/) {
		    print $x . "http://reverbnation.com.SQUIDINTERNAL/" . "$1" . "\n";

        #BLOGSPOT
} elsif (m/^http:\/\/[1-4].bp.(blogspot.com.*)/) {
        print $x . "http://blog-cdn." . $1  . "\n";

        #ytimg
} elsif (m/^http:\/\/i[1-4]\.ytimg\.com(.*)/) {
        print $x . "http://cdn.ytimg.com" . $1  . "\n";

        #AVAST
} elsif (m/^http:\/\/download[0-9]{3}.(avast.com.*)/) {
        print $x . "http://avast-cdn." . $1  .  "\n";

        #AVAST
} elsif (m/^http:\/\/[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\/(iavs.*)/) {
        print $x . "http://avast-cdn.avast.com/" . $1  .  "\n";

        #KAV
} elsif (m/^http:\/\/dnl-[0-9]{2}.(geo.kaspersky.com.*)/) {
        print $x . "http://kav-cdn." . $1  .  "\n";

        #AVG
} elsif (m/^http:\/\/update.avg.com/) {
        print $x . "http://avg-cdn." . $1  .  "\n";

        #maps.google.com
} elsif (m/^http:\/\/(cbk|mt|khm|mlt|tbn)[0-9]?(.google\.co(m|\.uk|\.id).*)/) {
        print $x . "http://" . $1  . $2 . "\n";

        #gstatic and/or wikimapia
} elsif (m/^http:\/\/([a-z])[0-9]?(\.gstatic\.com.*|\.wikimapia\.org.*)/) {
        print $x . "http://" . $1  . $2 . "\n";

        #maps.google.com
} elsif (m/^http:\/\/(khm|mt)[0-9]?(.google.com.*)/) {
        print $x . "http://" . $1  . $2 . "\n";
        #4shared
}elsif (m/^http:\/\/[a-zA-Z]{2}\d*\.4shared\.com(:8080|)\/download\/(.*)\/(.*\..*)\?.*/) {
print $x . "http://www.4shared.com.SQUIDINTERNAL/download/$2\/$3\n";
 
        #4shared preview
}elsif (m/^http:\/\/[a-zA-Z]{2}\d*\.4shared\.com(:8080|)\/img\/(\d*)\/\w*\/dlink__2Fdownload_2F(\w*)_3Ftsid_3D[\w-]*\/preview\.mp3\?sId=\w*/) {
print $x . "http://www.4shared.com.SQUIDINTERNAL/$2\n";

        #4shared audio/video preview
}elsif (($u =~ /4shared/) && (m/^http:\/\/(.*?)\.(.*?)\/(.*?)\/(dlink__2Fdownload_2F([^\/-]+))([a-zA-Z0-9-]+)\/([^\/\?\&]*\.[^\/\?\&]{2,3})(\?.*)?$/)) {
@y = ($1,$2,$3,$4,$7);
$y[0] =~ s/[a-z]+([0-9]+)?/cdn./;
print $x . "http://" . $y[0] . $y[1] . "/" . $y[2] . "/" . $y[3] . "/" . $y[4] . "\n";
    
#####  crontab untuk menghapus file yg sudah tidak terpakai lebih dari 1 jam yang lalu
### 0 * * * * find /var/log/squid/ -maxdepth 1 ! -name "access.*" -type f -mmin +60 -delete >> /dev/null 2>&1

} elsif ($X[1] =~ m/^http(|s)\:\/\/.*youtube.*(ptracking|stream_204|player_204|gen_204).*(video_id|docid|v)\=([^\&\s]*).*/){
        $vid = $4 ;
        @cpn = m/[&?]cpn\=([^\&\s]*)/;
		$fn = "/var/log/squid/@cpn";
		unless (-e $fn) {
			open FH,">".$fn ;
			print FH "$vid\n";
			close FH;
		} 
        print $x . $X[1] . "\n";

} elsif ($X[1] =~ m/^http\:\/\/.*(youtube|google).*videoplayback.*/){
        @itag = m/[&?](itag=[0-9]*)/;
        @ids = m/[&?]id\=([^\&\s]*)/;
        @mime = m/[&?](mime\=[^\&\s]*)/;
        @cpn = m/[&?]cpn\=([^\&\s]*)/;
		$fn = "/var/log/squid/@cpn";
		if (-e $fn) {
			open FH,"<".$fn ;
			$id  = <FH>;
			chomp $id ;
			close FH ;
	    } else {
			$id = $ids[0] ;
		} 
        @range = m/[&?](range=[^\&\s]*)/;
        print $x . "http://video-srv.youtube.com.SQUIDINTERNAL/id=" . $id . "&@itag@range@mime\n";
        
        
                        #Google
} elsif (m/^http:\/\/www\.google-analytics\.com\/__utm\.gif\?.*/) {
        print $x . "http://www.google-analytics.com/__utm.gif\n";

                        #Cache High Latency Ads
} elsif (m/^http:\/\/([a-z0-9.]*)(\.doubleclick\.net|\.quantserve\.com|\.googlesyndication\.com|yieldmanager|cpxinteractive)(.*)/) {
        $y = $3;$z = $2;
        for ($y) {
        s/pixel;.*/pixel/;
        s/activity;.*/activity/;
        s/(imgad[^&]*).*/\1/;
        s/;ord=[?0-9]*//;
        s/;&timestamp=[0-9]*//;
        s/[&?]correlator=[0-9]*//;
        s/&cookie=[^&]*//;
        s/&ga_hid=[^&]*//;
        s/&ga_vid=[^&]*//;
        s/&ga_sid=[^&]*//;
        # s/&prev_slotnames=[^&]*//
        # s/&u_his=[^&]*//;
        s/&dt=[^&]*//;
        s/&dtd=[^&]*//;
        s/&lmt=[^&]*//;
        s/(&alternate_ad_url=http%3A%2F%2F[^(%2F)]*)[^&]*/\1/;
        s/(&url=http%3A%2F%2F[^(%2F)]*)[^&]*/\1/;
        s/(&ref=http%3A%2F%2F[^(%2F)]*)[^&]*/\1/;
        s/(&cookie=http%3A%2F%2F[^(%2F)]*)[^&]*/\1/;
        s/[;&?]ord=[?0-9]*//;
        s/[;&]mpvid=[^&;]*//;
        s/&xpc=[^&]*//;
        # yieldmanager
        s/\?clickTag=[^&]*//;
        s/&u=[^&]*//;
        s/&slotname=[^&]*//;
        s/&page_slots=[^&]*//;
        }
        print $x . "http://" . $1 . $2 . $y . "\n";

                        #cache high latency ads
} elsif (m/^http:\/\/(.*?)\/(ads)\?(.*?)/) {
        print $x . "http://" . $1 . "/" . $2  . "\n";

} elsif (m/^http:\/\/(www\.ziddu\.com.*\.[^\/]{3,4})\/(.*?)/) {
        print $x . "http://" . $1 . "\n";

                        #cdn, varialble 1st path
} elsif (($X[1] =~ /filehippo/) && (m/^http:\/\/(.*?)\.(.*?)\/(.*?)\/(.*)\.([a-z0-9]{3,4})(\?.*)?/)) {
        @y = ($1,$2,$4,$5);
        $y[0] =~ s/[a-z0-9]{2,5}/cdn./;
        print $x . "http://" . $y[0] . $y[1] . "/" . $y[2] . "." . $y[3] . "\n";

                        #rapidshare
} elsif (($X[1] =~ /rapidshare/) && (m/^http:\/\/(([A-Za-z]+[0-9-.]+)*?)([a-z]*\.[^\/]{3}\/[a-z]*\/[0-9]*)\/(.*?)\/([^\/\?\&]{4,})$/)) {
        print $x . "http://cdn." . $3 . "/SQUIDINTERNAL/" . $5 . "\n";

} elsif (($X[1] =~ /maxporn/) && (m/^http:\/\/([^\/]*?)\/(.*?)\/([^\/]*?)(\?.*)?$/)) {
        print $x . "http://" . $1 . "/SQUIDINTERNAL/" . $3 . "\n";
        
                        #domain/path/.*/path/filename
} elsif (($X[1] =~ /fucktube/) && (m/^http:\/\/(.*?)(\.[^\.\-]*?[^\/]*\/[^\/]*)\/(.*)\/([^\/]*)\/([^\/\?\&]*)\.([^\/\?\&]{3,4})(\?.*?)$/)) {
        @y = ($1,$2,$4,$5,$6);
        $y[0] =~ s/(([a-zA-A]+[0-9]+(-[a-zA-Z])?$)|([^\.]*cdn[^\.]*)|([^\.]*cache[^\.]*))/cdn/;
        print $x . "http://" . $y[0] . $y[1] . "/" . $y[2] . "/" . $y[3] . "." . $y[4] . "\n";

                        #like porn hub variables url and center part of the path, filename etention 3 or 4 with or without ? at the end
} elsif (($X[1] =~ /tube8|pornhub|xvideos/) && (m/^http:\/\/(([A-Za-z]+[0-9-.]+)*?(\.[a-z]*)?)\.([a-z]*[0-9]?\.[^\/]{3}\/[a-z]*)(.*?)((\/[a-z]*)?(\/[^\/]*){4}\.[^\/\?]{3,4})(\?.*)?$/)) {
        print $x . "http://cdn." . $4 . $6 . "\n";

                        #for yimg.com video
} elsif (m/^http:\/\/(.*yimg.com)\/\/(.*)\/([^\/\?\&]*\/[^\/\?\&]*\.[^\/\?\&]{3,4})(\?.*)?$/) {
        print $x . "http://cdn.yimg.com/" . $3 . "\n";
        
                        #for yimg.com doubled
} elsif (m/^http:\/\/(.*?)\.yimg\.com\/(.*?)\.yimg\.com\/(.*?)\?(.*)/) {
        print $x . "http://cdn.yimg.com/"  . $3 . "\n";

                        #for yimg.com with &sig=
} elsif (m/^http:\/\/([^\.]*)\.yimg\.com\/(.*)/) {
        @y = ($1,$2);
        $y[0] =~ s/[a-z]+([0-9]+)?/cdn/;
        $y[1] =~ s/&sig=.*//;
        print $x . "http://" . $y[0] . ".yimg.com/"  . $y[1] . "\n";
                        
                        #youjizz. We use only domain and filename
} elsif (($X[1] =~ /media[0-9]{1,5}\.youjizz/) && (m/^http:\/\/(.*?)(\.[^\.\-]*?\.[^\/]*)\/(.*)\/([^\/\?\&]*)\.([^\/\?\&]{3,4})(\?.*?)$/)) {
        @y = ($1,$2,$4,$5);
        $y[0] =~ s/(([a-zA-A]+[0-9]+(-[a-zA-Z])?$)|([^\.]*cdn[^\.]*)|([^\.]*cache[^\.]*))/cdn/;
        print $x . "http://" . $y[0] . $y[1] . "/" . $y[2] . "." . $y[3] . "\n";

                        #general purpose for cdn servers. add above your specific servers.
} elsif (m/^http:\/\/([0-9.]*?)\/\/(.*?)\.(.*)\?(.*?)/) {
        print $x . "http://squid-cdn-url/" . $2  . "." . $3 . "\n";

                        # spicific extention
} elsif (m/^http:\/\/(.*?)\.(jp(e?g|e|2)|gif|png|tiff?|bmp|ico|flv|wmv|3gp|mp(4|3)|exe|msi|zip|on2|mar|swf).*?/) {
        @y = ($1,$2);
         $y[0] =~ s/((cache|cdn)[-\d]*)|([a-zA-A]+-?[0-9]+(-[a-zA-Z]*)?)/cdn/;
         print $x . "http://" . $y[0] . "." . $y[1] . "\n";

                        #generic http://variable.domain.com/path/filename."ex", "ext" or "exte"
                        #http://cdn1-28.projectplaylist.com
                        #http://s1sdlod041.bcst.cdn.s1s.yimg.com
} elsif (m/^http:\/\/(.*?)(\.[^\.\-]*?\..*?)\/([^\?\&\=]*)\.([\w\d]{2,4})\??.*$/) {
        @y = ($1,$2,$3,$4);
        $y[0] =~ s/([a-z][0-9][a-z]dlod[\d]{3})|((cache|cdn)[-\d]*)|([a-zA-A]+-?[0-9]+(-[a-zA-Z]*)?)/cdn/;
        print $x . "storeurl://" . $y[0] . $y[1] . "/" . $y[2] . "." . $y[3] . "\n";

                        # all that ends with ;
} elsif (m/^http:\/\/(.*?)\/(.*?)\;(.*)/) {
        print $x . "http://" . $1 . "/" . $2  . "\n";

} else {
        print $x . $X[1] . "\n";
}
}

