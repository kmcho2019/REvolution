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
    // Stage 0: shift by 4 bits (rotate left)
    wire [7:0] stage0_shifted;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_shift4
            // Calculate rotated index for shift by 4
            wire rotated_bit = in[(i + 4) % 8];
            mux2X1 mux4 (
                .d0(in[i]),
                .d1(rotated_bit),
                .sel(ctrl[2]),
                .y(stage0_shifted[i])
            );
        end
    endgenerate

    // Stage 1: shift by 2 bits (rotate left)
    wire [7:0] stage1_shifted;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_shift2
            wire rotated_bit = stage0_shifted[(i + 2) % 8];
            mux2X1 mux2 (
                .d0(stage0_shifted[i]),
                .d1(rotated_bit),
                .sel(ctrl[1]),
                .y(stage1_shifted[i])
            );
        end
    endgenerate

    // Stage 2: shift by 1 bit (rotate left)
    wire [7:0] stage2_shifted;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_shift1
            wire rotated_bit = stage1_shifted[(i + 1) % 8];
            mux2X1 mux1 (
                .d0(stage1_shifted[i]),
                .d1(rotated_bit),
                .sel(ctrl[0]),
                .y(stage2_shifted[i])
            );
        end
    endgenerate

    assign out = stage2_shifted;

endmodule