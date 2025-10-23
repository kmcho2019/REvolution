module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    wire [7:0] stage1; // after 4-bit shift
    wire [7:0] stage2; // after 2-bit shift
    wire [7:0] stage3; // after 1-bit shift

    genvar i;

    // Stage 1: shift by 4 if ctrl[2] == 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_muxes
            // rotate left by 4: (i+4)%8
            mux2X1 mux_stage1 (
                .in0(in[i]),
                .in1(in[(i + 4) & 3'b111]),
                .sel(ctrl[2]),
                .out(stage1[i])
            );
        end
    endgenerate

    // Stage 2: shift by 2 if ctrl[1] == 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_muxes
            // rotate left by 2: (i+2)%8
            mux2X1 mux_stage2 (
                .in0(stage1[i]),
                .in1(stage1[(i + 2) & 3'b111]),
                .sel(ctrl[1]),
                .out(stage2[i])
            );
        end
    endgenerate

    // Stage 3: shift by 1 if ctrl[0] == 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3_muxes
            // rotate left by 1: (i+1)%8
            mux2X1 mux_stage3 (
                .in0(stage2[i]),
                .in1(stage2[(i + 1) & 3'b111]),
                .sel(ctrl[0]),
                .out(stage3[i])
            );
        end
    endgenerate

    assign out = stage3;

endmodule