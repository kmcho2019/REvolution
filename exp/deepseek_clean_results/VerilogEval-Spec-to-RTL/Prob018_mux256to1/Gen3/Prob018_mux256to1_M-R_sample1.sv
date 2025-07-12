module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // First stage: 16 groups of 16-to-1 muxes
    wire [15:0] stage1_out;
    
    assign stage1_out[0] = in[0 + sel[3:0]];
    assign stage1_out[1] = in[16 + sel[3:0]];
    assign stage1_out[2] = in[32 + sel[3:0]];
    assign stage1_out[3] = in[48 + sel[3:0]];
    assign stage1_out[4] = in[64 + sel[3:0]];
    assign stage1_out[5] = in[80 + sel[3:0]];
    assign stage1_out[6] = in[96 + sel[3:0]];
    assign stage1_out[7] = in[112 + sel[3:0]];
    assign stage1_out[8] = in[128 + sel[3:0]];
    assign stage1_out[9] = in[144 + sel[3:0]];
    assign stage1_out[10] = in[160 + sel[3:0]];
    assign stage1_out[11] = in[176 + sel[3:0]];
    assign stage1_out[12] = in[192 + sel[3:0]];
    assign stage1_out[13] = in[208 + sel[3:0]];
    assign stage1_out[14] = in[224 + sel[3:0]];
    assign stage1_out[15] = in[240 + sel[3:0]];

    // Second stage: final 16-to-1 mux
    assign out = stage1_out[sel[7:4]];

endmodule