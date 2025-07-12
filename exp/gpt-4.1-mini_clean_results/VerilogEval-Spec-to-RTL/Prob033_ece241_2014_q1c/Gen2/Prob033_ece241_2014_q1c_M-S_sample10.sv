module TopModule(
    input  signed [7:0] a,
    input  signed [7:0] b,
    output signed [7:0] s,
    output              overflow
);

assign s = a + b;
// Overflow occurs if a and b have the same sign but s has a different sign
assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);

endmodule