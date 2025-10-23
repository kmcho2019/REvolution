module TopModule (
    input  wire [3:0] in,
    output wire [2:0] out_both,       // Only bits [0:2] used, out_both[3] always 0 removed
    output wire [2:0] out_any,        // Only bits [1:3] used, out_any[0] always 0 removed
    output wire [3:0] out_different   // All bits used with wrap-around
);

    // out_both: bits 0 to 2 only, each bit = in[i] & in[i+1]
    assign out_both = { (in[2] & in[3]), (in[1] & in[2]), (in[0] & in[1]) };

    // out_any: bits 1 to 3 only, each bit = in[i] | in[i-1]
    // indexing out_any[2:0] maps to original bits [1:3]
    assign out_any = { (in[3] | in[2]), (in[2] | in[1]), (in[1] | in[0]) };

    // out_different: 4 bits with wrap-around XOR of bit with left neighbor
    assign out_different[0] = in[0] ^ in[1];
    assign out_different[1] = in[1] ^ in[2];
    assign out_different[2] = in[2] ^ in[3];
    assign out_different[3] = in[3] ^ in[0];

endmodule