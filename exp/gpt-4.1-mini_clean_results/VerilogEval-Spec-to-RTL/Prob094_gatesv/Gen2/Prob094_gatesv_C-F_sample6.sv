module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // out_both[3] has no left neighbor, explicitly zero
    assign out_both[3] = 1'b0;
    // out_both[2:0] = in[2:0] & in[3:1]
    assign out_both[2:0] = in[2:0] & in[3:1];

    // out_any[0] has no right neighbor, explicitly zero
    assign out_any[0] = 1'b0;
    // out_any[3:1] = in[3:1] | in[2:0]
    assign out_any[3:1] = in[3:1] | in[2:0];

    // out_different[i] = in[i] ^ in[(i+1) mod 4], wrapping around
    assign out_different = in ^ {in[0], in[3:1]};

endmodule