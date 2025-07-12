module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Internal wires for neighbors
    wire [2:0] left_neighbors = in[3:1];     // bits 3 down to 1
    wire [2:0] right_neighbors = in[2:0];    // bits 2 down to 0

    // out_both: bits 0..2 = in[i] & in[i+1]; bit 3 = 0 (no left neighbor)
    assign out_both[3] = 1'b0;
    assign out_both[2:0] = in[2:0] & in[3:1];

    // out_any: bits 1..3 = in[i] | in[i-1]; bit 0 = 0 (no right neighbor)
    assign out_any[0] = 1'b0;
    assign out_any[3:1] = in[3:1] | in[2:0];

    // out_different: wrap-around XOR with left neighbor (i+1 mod 4)
    assign out_different[0] = in[0] ^ in[1];
    assign out_different[1] = in[1] ^ in[2];
    assign out_different[2] = in[2] ^ in[3];
    assign out_different[3] = in[3] ^ in[0];

endmodule