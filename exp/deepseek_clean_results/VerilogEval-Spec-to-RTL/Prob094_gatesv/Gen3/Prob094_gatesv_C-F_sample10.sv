module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Efficient bit-sliced AND for out_both (lower 3 bits)
    assign out_both[2:0] = in[3:1] & in[2:0];
    assign out_both[3] = 1'b0;  // Explicit don't-care handling

    // Efficient bit-sliced OR for out_any (upper 3 bits)
    assign out_any[3:1] = in[3:1] | in[2:0];
    assign out_any[0] = 1'b0;   // Explicit don't-care handling

    // Clear XOR implementation for wrap-around difference
    assign out_different[3] = in[3] ^ in[0];
    assign out_different[2] = in[2] ^ in[3];
    assign out_different[1] = in[1] ^ in[2];
    assign out_different[0] = in[0] ^ in[1];

endmodule