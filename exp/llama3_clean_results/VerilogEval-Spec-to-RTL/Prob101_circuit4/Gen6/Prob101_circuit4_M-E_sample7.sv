module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

// Simplify the logic expression further
assign q = (a && (b || c)) || (!a && (b || c));

// Alternatively, since d does not affect the output based on the given waveforms,
// and noticing the pattern where q is high whenever b or c is high regardless of a,
// a further simplified version focusing on the essential logic without a could be:
assign q = b || c;

endmodule