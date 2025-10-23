module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // out_both: bits 0 to 2: AND with neighbor to left (higher index), bit 3 = 0
    assign out_both[2:0] = in[2:0] & in[3:1];
    assign out_both[3] = 1'b0;

    // out_any: bits 1 to 3: OR with neighbor to right (lower index), bit 0 = 0
    assign out_any[3:1] = in[3:1] | in[2:0];
    assign out_any[0] = 1'b0;

    // out_different: explicitly unrolled without modulo for synthesis friendliness
    assign out_different[0] = in[0] ^ in[1];
    assign out_different[1] = in[1] ^ in[2];
    assign out_different[2] = in[2] ^ in[3];
    assign out_different[3] = in[3] ^ in[0];

endmodule