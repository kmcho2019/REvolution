module mux2X1(
    input [7:0] in0,
    input [7:0] in1,
    input sel,
    output [7:0] out
);

    assign out = sel ? in1 : in0;

endmodule

module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

    // Stage 1: Shift by 4 positions
    wire [7:0] stage1_out;
    mux2X1 stage1_mux(
        .in0(in),
        .in1({in[3:0], 4'b0000}),
        .sel(ctrl[2]),
        .out(stage1_out)
    );

    // Stage 2: Shift by 2 positions
    wire [7:0] stage2_out;
    mux2X1 stage2_mux(
        .in0(stage1_out),
        .in1({stage1_out[5:0], 2'b00}),
        .sel(ctrl[1]),
        .out(stage2_out)
    );

    // Stage 3: Shift by 1 position
    wire [7:0] stage3_out;
    mux2X1 stage3_mux(
        .in0(stage2_out),
        .in1({stage2_out[6:0], 1'b0}),
        .sel(ctrl[0]),
        .out(stage3_out)
    );

    // Final output
    assign out = stage3_out;

endmodule