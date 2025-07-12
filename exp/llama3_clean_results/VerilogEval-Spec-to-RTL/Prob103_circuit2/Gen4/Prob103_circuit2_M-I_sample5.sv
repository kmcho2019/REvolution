module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Directly implement the observed logic from the simulation waveforms
// q is 1 when an odd number of inputs are 1, or when all inputs are 0
assign q = ~(a ^ b ^ c ^ d);

endmodule