%First we need to import an audio file
[y,Fs]=audioread('piano-C4.wav');
%sound(y,Fs);

%Now we have the audio tune set for use
%First we will plot the signal
info=audioinfo('piano-C4.wav');
t=0:(1/Fs):(info.Duration);
t=t(1:end-1);
plot(t,y)


maximum=max(abs(y));
mark=0.6*maximum;
%Again we have the plot now and this is amazing
start=0;
stop=0;
trigger=0;
note_pos=[];
note_freq=[];
i=1;
while i<info.TotalSamples-500
    %We will calculate the maxvalue around the considered index point
    max_val=max(abs(y(i:i+500)));
    if max_val < mark
        if trigger==1
            stop=i;
            temp=round((start+stop)/2);
            %Call Fourier analyzer at this point
            Y=fft(y(start:stop));
            freq_max=max(abs(Y));
            j=1;
            while j<(stop-start)/2
                if abs(Y(j))>0.6*freq_max
                    note_pos=[note_pos, temp];
                    note_freq=[note_freq, Fs*j/(stop-start+1)];
                    j=j+1;
                else
                    j=j+1;
                end
            end
            trigger=0;
            i=i+500;
        else
            i=i+500;
        end
    else
        if trigger==0
            start=i;
            trigger=1;
            i=i+500;
        else
            i=i+500;
        end
    end
end
note_pos/Fs
note_freq

plot(t,fft(y))
