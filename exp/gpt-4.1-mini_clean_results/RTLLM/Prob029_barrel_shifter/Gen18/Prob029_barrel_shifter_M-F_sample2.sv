module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    // Intermediate signals between stages
    wire [7:0] stage1_out;
    wire [7:0] stage2_out;

    // Rotate left by 4 bits
    wire [7:0] rot4 = {in[3:0], in[7:4]};

    // Stage 1: shift by 4 if ctrl[2] is high
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_mux
            mux2X1 mux_stage1 (
                .in0(in[i]),
                .in1(rot4[i]),
                .sel(ctrl[2]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Rotate left stage1_out by 2 bits
    wire [7:0] rot2_stage1 = {stage1_out[5:0], stage1_out[7:6]};

    // Stage 2: shift by 2 if ctrl[1] is high
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_mux
            mux2X1 mux_stage2 (
                .in0(stage1_out[i]),
                .in1(rot2_stage1[i]),
                .sel(ctrl[1]),
                .out(stage2_out[i])
            );
        end
    endgenerate

    // Rotate left stage2_out by 1 bit
    wire [7:0] rot1_stage2 = {stage2_out[6:0], stage2_out[7]};

    // Stage 3: shift by 1 if ctrl[0] is high
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3_mux
            mux2X1 mux_stage3 (
                .in0(stage2_out[i]),
                .in1(rot1_stage2[i]),
                .sel(ctrl[0]),
                .out(out[i])
            );
        end
    endgenerate

endmodule