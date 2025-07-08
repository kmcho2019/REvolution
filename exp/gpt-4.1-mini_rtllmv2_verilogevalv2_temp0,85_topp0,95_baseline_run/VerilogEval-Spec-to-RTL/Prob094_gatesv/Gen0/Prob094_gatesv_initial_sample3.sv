module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: both this bit and the neighbor to the left (higher index) are 1
    // For bits 0 to 2
    assign out_both[2:0] = in[2:0] & in[3:1];
    // bit 3 has no left neighbor, so 0
    assign out_both[3] = 1'b0;

    // out_any: either this bit or neighbor to right (lower index) is 1
    // For bits 1 to 3
    assign out_any[3:1] = in[3:1] | in[2:0];
    // bit 0 has no right neighbor, so 0
    assign out_any[0] = 1'b0;

    // out_different: bit differs from neighbor to left (wrap-around)
    assign out_different[3] = in[3] ^ in[0];
    assign out_different[2] = in[2] ^ in[3];
    assign out_different[1] = in[1] ^ in[2];
    assign out_different[0] = in[0] ^ in[1];

endmodule