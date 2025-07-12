module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Directly compute output based on XOR results without intermediate signals
    // This approach is simple and efficient
    assign out = a ^ b ^ c ^ d;

    // Alternatively, consider paired XOR operations for potential synthesis advantages
    // assign out = (a ^ b) ^ (c ^ d);

endmodule