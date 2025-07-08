module mux2X1(
    input wire i0,
    input wire i1,
    input wire sel,
    output wire y
);
    assign y = sel ? i1 : i0;
endmodule

module barrel_shifter(
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    wire [7:0] stage1;
    wire [7:0] stage2;

    // Stage 1: shift by 4 if ctrl[2] == 1
    // rotated left by 4 positions
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_shift
            mux2X1 mux4(
                .i0(in[i]),
                .i1(in[(i + 4) % 8]),
                .sel(ctrl[2]),
                .y(stage1[i])
            );
        end
    endgenerate

    // Stage 2: shift by 2 if ctrl[1] == 1
    // rotated left by 2 positions
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_shift
            mux2X1 mux2(
                .i0(stage1[i]),
                .i1(stage1[(i + 2) % 8]),
                .sel(ctrl[1]),
                .y(stage2[i])
            );
        end
    endgenerate

    // Stage 3: shift by 1 if ctrl[0] == 1
    // rotated left by 1 position
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3_shift
            mux2X1 mux1(
                .i0(stage2[i]),
                .i1(stage2[(i + 1) % 8]),
                .sel(ctrl[0]),
                .y(out[i])
            );
        end
    endgenerate

endmodule