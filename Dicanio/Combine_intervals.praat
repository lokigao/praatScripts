#Script that combines two adjacent intervals in a textgrid into one with a new label.
#Copyright Christian DiCanio, Haskins Laboratories, 2014.

form Combine intervals in Textgrids
   sentence Directory_name: /Linguistics/Arapaho/HK_textgrids/
   positive Segment_tier_number 1
   sentence Preceding_label S
   sentence Following_label AE1
   sentence New_label_name foo
endform

Create Strings as file list... list 'directory_name$'/*.TextGrid
num = Get number of strings
for ifile to num
	select Strings list
	fileName$ = Get string... ifile
	Read from file... 'directory_name$'/'fileName$'
	tgID = selected("TextGrid")
	num_labels = Get number of intervals... segment_tier_number

		for i to num_labels
			select 'tgID'
			label_p$ = Get label of interval... segment_tier_number i
		
			if label_p$ = preceding_label$
				label_f$ = Get label of interval... segment_tier_number (i+1)
				if label_f$ = following_label$
					Remove right boundary: segment_tier_number, i
					Set interval text: segment_tier_number, i, new_label_name$
				else
					#Do nothing
				endif
		else	
			#do nothing
		endif

		#This next part is crucial; as we are reducing the total number of intervals, we have to recalculate
		#the number after every cycle. Otherwise, the number of intervals is larger than those now found
		#in the textgrid.

		num_labels = Get number of intervals... segment_tier_number

		endfor

	select tgID
	lengthFN = length (fileName$)
	newfilename$ = left$ (fileName$, lengthFN-9)
	Save as text file: "'directory_name$'/'newfilename$'_modified.TextGrid"
endfor