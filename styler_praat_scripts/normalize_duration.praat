# Duration Matcher
# Will Styler - 2015
# 
# This Praat script will create duration normalized stimuli in WAV format and save to a new directory
# This works best for scaling within a few hundred ms.  If you try to make something 10 seconds long, it won't work well :)


form Normalize Amplitude in sound files
	comment Sound file extension:
	     optionmenu file_type: 2
	     option .aiff
	     option .wav
	comment What duration (in ms) do you want to set to?
   		positive goaldur 120
	comment What's the lowest reasonable pitch (for PSOLA)?
	   		positive crazylowh1 80
	comment What's the highest reasonable pitch?
	   		positive crazyhighh1 300
endform

directory$ = chooseDirectory$ ("Choose the directory containing sound files and textgrids")
directory$ = "'directory$'" + "/" 

Create Strings as file list... list 'directory$'*'file_type$'
number_files = Get number of strings

for ifile to number_files
	select Strings list
	sound$ = Get string... ifile
	Read from file... 'directory$''sound$'
	soundname$ = selected$ ("Sound", 1)
	startdur = Get total duration
	startdurms = startdur * 1000
	durfactor = goaldur/startdurms
	select Sound 'soundname$'
	Lengthen (overlap-add): 'crazylowh1', 'crazyhighh1', 'durfactor'
	Write to WAV file... 'directory$''soundname$'_'goaldur'ms.wav
	select Sound 'soundname$'
	Remove
endfor

select Strings list
Remove
