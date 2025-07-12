module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire out
);
    // Compute parity (XOR) of all inputs directly
    // This matches the Karnaugh map pattern exactly,
    // producing '1' for odd parity input combinations.
    assign out = a ^ b ^ c ^ d;

endmodule