module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

assign q = ~(a ^ b ^ c ^ d); // Using ~ to invert the result of XOR, so q is 1 for even parity

endmodule