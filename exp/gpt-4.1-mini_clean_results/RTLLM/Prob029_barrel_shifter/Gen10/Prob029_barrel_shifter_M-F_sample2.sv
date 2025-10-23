module mux2X1 (
    input  wire d0,
    input  wire d1,
    input  wire sel,
    output wire y
);
    assign y = sel ? d1 : d0;
endmodule

module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    // Wires for stage outputs
    wire [7:0] stage1, stage2;

    genvar i;

    // Stage 1: Shift by 4 bits if ctrl[2] == 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : STAGE1_MUX
            // Compute the bit to shift by 4 with wrap-around (rotate left by 4)
            wire shifted_bit = in[(i + 4) % 8];
            mux2X1 mux_stage1 (
                .d0(in[i]),
                .d1(shifted_bit),
                .sel(ctrl[2]),
                .y(stage1[i])
            );
        end
    endgenerate

    // Stage 2: Shift by 2 bits if ctrl[1] == 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : STAGE2_MUX
            wire shifted_bit = stage1[(i + 2) % 8];
            mux2X1 mux_stage2 (
                .d0(stage1[i]),
                .d1(shifted_bit),
                .sel(ctrl[1]),
                .y(stage2[i])
            );
        end
    endgenerate

    // Stage 3: Shift by 1 bit if ctrl[0] == 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : STAGE3_MUX
            wire shifted_bit = stage2[(i + 1) % 8];
            mux2X1 mux_stage3 (
                .d0(stage2[i]),
                .d1(shifted_bit),
                .sel(ctrl[0]),
                .y(out[i])
            );
        end
    endgenerate

endmodule