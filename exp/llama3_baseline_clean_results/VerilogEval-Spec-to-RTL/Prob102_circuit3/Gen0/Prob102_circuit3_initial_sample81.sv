module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

assign q = (a && (b || d)) || (!a && (b && d));

// The above line of code implements the logic based on observation from waveforms.
// However, considering the waveform where a=0, b=1, and d=0, q=1, it seems
// the logic can actually be simplified to consider the OR of b and d when a=0.
// But to fully match the given waveform, especially when a=1, b=0, and d=1, q=1,
// it indicates that when a=1, both b and d don't need to be true for q to be 1.
// Therefore, the corrected logic would be:

// Whenever a is 1, q should be 1 if either b or d is 1.
// Whenever a is 0, q should be 1 if both b and d are 1.
// But looking closely at the waveforms again, it seems the influence of c is not as
// previously dismissed. The actual logic seems to follow the rule: q = 1 when a or b or d is 1.

assign q = a || b || d;

endmodule