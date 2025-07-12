// 2-to-1 Multiplexer module for single bit
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

    wire [7:0] stage1; // after shift by 4 controlled by ctrl[2]
    wire [7:0] stage2; // after shift by 2 controlled by ctrl[1]
    wire [7:0] stage3; // after shift by 1 controlled by ctrl[0]

    genvar i;

    // Stage 1: rotate by 4 bits if ctrl[2] is 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_mux
            // rotated bit index with wrap-around
            wire rotated_bit = in[(i + 4) % 8];
            mux2X1 mux_stage1(
                .d0(in[i]),
                .d1(rotated_bit),
                .sel(ctrl[2]),
                .y(stage1[i])
            );
        end
    endgenerate

    // Stage 2: rotate by 2 bits if ctrl[1] is 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_mux
            wire rotated_bit = stage1[(i + 2) % 8];
            mux2X1 mux_stage2(
                .d0(stage1[i]),
                .d1(rotated_bit),
                .sel(ctrl[1]),
                .y(stage2[i])
            );
        end
    endgenerate

    // Stage 3: rotate by 1 bit if ctrl[0] is 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3_mux
            wire rotated_bit = stage2[(i + 1) % 8];
            mux2X1 mux_stage3(
                .d0(stage2[i]),
                .d1(rotated_bit),
                .sel(ctrl[0]),
                .y(stage3[i])
            );
        end
    endgenerate

    assign out = stage3;

endmodule