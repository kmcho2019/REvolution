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
    wire [7:0] stage4, stage2, stage1;

    // Stage 4 shift: rotate left by 4 bits if ctrl[2] == 1
    // Rotate left 4: bits [3:0] become bits [7:4], bits [7:4] become bits [3:0]
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_stage4
            mux2X1 mux4 (
                .d0(in[i]),
                .d1(in[(i+4) % 8]),
                .sel(ctrl[2]),
                .y(stage4[i])
            );
        end
    endgenerate

    // Stage 2 shift: rotate left by 2 bits if ctrl[1] == 1, input is stage4
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_stage2
            mux2X1 mux2 (
                .d0(stage4[i]),
                .d1(stage4[(i+2) % 8]),
                .sel(ctrl[1]),
                .y(stage2[i])
            );
        end
    endgenerate

    // Stage 1 shift: rotate left by 1 bit if ctrl[0] == 1, input is stage2
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_stage1
            mux2X1 mux1 (
                .d0(stage2[i]),
                .d1(stage2[(i+1) % 8]),
                .sel(ctrl[0]),
                .y(stage1[i])
            );
        end
    endgenerate

    assign out = stage1;

endmodule