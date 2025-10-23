module mux2X1 (
    input  wire in0,
    input  wire in1,
    input  wire sel,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    // Stage 1 wires (shift by 4)
    wire [7:0] stage1_shifted;
    wire [7:0] stage1_out;

    // Stage 2 wires (shift by 2)
    wire [7:0] stage2_shifted;
    wire [7:0] stage2_out;

    // Stage 3 wires (shift by 1)
    wire [7:0] stage3_shifted;
    wire [7:0] stage3_out;

    // Prepare shifted versions for stage 1 (rotate left by 4)
    assign stage1_shifted = {in[3:0], in[7:4]};

    genvar i;
    generate
        // Stage 1 muxes: select between in[i] and in rotated left by 4
        for (i = 0; i < 8; i = i + 1) begin : STAGE1_MUX
            mux2X1 mux1 (
                .in0(in[i]),
                .in1(stage1_shifted[i]),
                .sel(ctrl[2]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Prepare shifted versions for stage 2 (rotate left by 2)
    assign stage2_shifted = {stage1_out[5:0], stage1_out[7:6]};

    generate
        // Stage 2 muxes: select between stage1_out[i] and shifted by 2
        for (i = 0; i < 8; i = i + 1) begin : STAGE2_MUX
            mux2X1 mux2 (
                .in0(stage1_out[i]),
                .in1(stage2_shifted[i]),
                .sel(ctrl[1]),
                .out(stage2_out[i])
            );
        end
    endgenerate

    // Prepare shifted versions for stage 3 (rotate left by 1)
    assign stage3_shifted = {stage2_out[6:0], stage2_out[7]};

    generate
        // Stage 3 muxes: select between stage2_out[i] and shifted by 1
        for (i = 0; i < 8; i = i + 1) begin : STAGE3_MUX
            mux2X1 mux3 (
                .in0(stage2_out[i]),
                .in1(stage3_shifted[i]),
                .sel(ctrl[0]),
                .out(stage3_out[i])
            );
        end
    endgenerate

    assign out = stage3_out;

endmodule