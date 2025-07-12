module barrel_shifter #(
    parameter DIRECTION = 0  // 0=right, 1=left
) (
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

    // Stage 0: Shift by 4
    wire [7:0] shift4 = DIRECTION ? {in[3:0], in[7:4]} : {in[3:0], in[7:4]};
    wire [7:0] stage0 = ctrl[2] ? shift4 : in;

    // Stage 1: Shift by 2
    wire [7:0] shift2 = DIRECTION ? {stage0[5:0], stage0[7:6]} : {stage0[1:0], stage0[7:2]};
    wire [7:0] stage1 = ctrl[1] ? shift2 : stage0;

    // Stage 2: Shift by 1
    wire [7:0] shift1 = DIRECTION ? {stage1[6:0], stage1[7]} : {stage1[0], stage1[7:1]};
    assign out = ctrl[0] ? shift1 : stage1;

endmodule