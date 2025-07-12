module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Internal wire for parity of inputs
    wire parity;

    // Compute parity as XOR of all inputs
    assign parity = a ^ b ^ c ^ d;

    // Assign output directly from parity
    assign out = parity;

endmodule