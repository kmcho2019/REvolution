module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire parity;          // XOR of all inputs
    assign parity = a ^ b ^ c ^ d;
    assign q = ~parity;   // Even parity output

endmodule