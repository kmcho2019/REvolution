module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);
    // Even parity detector - compact implementation
    assign q = ~(a ^ b ^ c ^ d);  // XOR all inputs and invert for even parity
endmodule