module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// The logic for q is the XOR of all inputs, which matches the observed pattern
// when correctly interpreting the truth table and simulation waveforms.
assign q = a ^ b ^ c ^ d;

endmodule