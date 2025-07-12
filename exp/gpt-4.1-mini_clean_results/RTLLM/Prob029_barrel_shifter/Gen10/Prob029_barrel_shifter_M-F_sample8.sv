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

    wire [7:0] stage1;
    wire [7:0] stage2;

    genvar i;

    // Stage 1: Shift by 4 if ctrl[2] = 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_muxes
            // Calculate index shifted by 4 (rotate right by 4)
            // For rotation right by N: output[i] = input[(i + N) % 8]
            // Since the problem states rotating bits efficiently with muxes,
            // and each stage shift is a right rotation by that stage's amount,
            // we can rotate right by the shift amount.
            mux2X1 mux4 (
                .d0(in[i]),
                .d1(in[(i + 4) & 3'h7]),
                .sel(ctrl[2]),
                .y(stage1[i])
            );
        end
    endgenerate

    // Stage 2: Shift by 2 if ctrl[1] = 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_muxes
            mux2X1 mux2 (
                .d0(stage1[i]),
                .d1(stage1[(i + 2) & 3'h7]),
                .sel(ctrl[1]),
                .y(stage2[i])
            );
        end
    endgenerate

    // Stage 3: Shift by 1 if ctrl[0] = 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3_muxes
            mux2X1 mux1 (
                .d0(stage2[i]),
                .d1(stage2[(i + 1) & 3'h7]),
                .sel(ctrl[0]),
                .y(out[i])
            );
        end
    endgenerate

endmodule