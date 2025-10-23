module mux2X1 (
    input [7:0] in0,
    input [7:0] in1,
    input sel,
    output [7:0] out
);
    assign out = sel ? in1 : in0;
endmodule

module barrel_shifter #(
    parameter DIRECTION = 0  // 0=right, 1=left
) (
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

    wire [7:0] stage0, stage1, stage2;

    // Stage 0: Shift by 4
    wire [7:0] shift4 = DIRECTION ? {in[3:0], in[7:4]} : {in[3:0], in[7:4]};
    mux2X1 mux_stage0 (
        .in0(in),
        .in1(shift4),
        .sel(ctrl[2]),
        .out(stage0)
    );

    // Stage 1: Shift by 2
    wire [7:0] shift2 = DIRECTION ? {stage0[5:0], stage0[7:6]} : {stage0[1:0], stage0[7:2]};
    mux2X1 mux_stage1 (
        .in0(stage0),
        .in1(shift2),
        .sel(ctrl[1]),
        .out(stage1)
    );

    // Stage 2: Shift by 1
    wire [7:0] shift1 = DIRECTION ? {stage1[6:0], stage1[7]} : {stage1[0], stage1[7:1]};
    mux2X1 mux_stage2 (
        .in0(stage1),
        .in1(shift1),
        .sel(ctrl[0]),
        .out(out)
    );

endmodule