module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);
    assign q = ~(a ^ b ^ c ^ d);  // Single XOR reduction with inversion for even parity
endmodule