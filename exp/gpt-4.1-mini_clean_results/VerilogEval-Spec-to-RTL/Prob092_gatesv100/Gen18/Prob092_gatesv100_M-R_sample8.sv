module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // out_both: For bits 0 to 98, AND in[i] and in[i+1]; out_both[99] = 0
    assign out_both[98:0] = in[98:0] & in[99:1];
    assign out_both[99] = 1'b0;

    // out_any: For bits 1 to 99, OR in[i] and in[i-1]; out_any[0] = 0
    assign out_any[99:1] = in[99:1] | in[98:0];
    assign out_any[0] = 1'b0;

    // out_different: For bits 0 to 98, XOR in[i] and in[i+1];
    // out_different[99] = XOR of in[99] and in[0] (wrap-around)
    assign out_different[98:0] = in[98:0] ^ in[99:1];
    assign out_different[99] = in[99] ^ in[0];

endmodule