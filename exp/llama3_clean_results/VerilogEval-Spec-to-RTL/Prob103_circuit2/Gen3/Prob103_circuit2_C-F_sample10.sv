module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// The output q is the inverse of the XOR of all input bits, which is equivalent to
// the parity generator's output inverted. This is because the XOR of a set of bits
// is 1 if there is an odd number of 1's in the set, and 0 if there is an even number.
assign q = ~(a ^ b ^ c ^ d);

endmodule