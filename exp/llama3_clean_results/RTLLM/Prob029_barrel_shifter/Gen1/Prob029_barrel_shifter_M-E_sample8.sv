module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    wire [7:0] stage1_out;
    assign stage1_out = ctrl[2]? {in[3:0], 4'b0000} : in;

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    wire [7:0] stage2_out;
    assign stage2_out = ctrl[1]? {stage1_out[5:0], 2'b00} : stage1_out;

    // Stage 3: Shift by 1 position if ctrl[0] is high
    assign out = ctrl[0]? {stage2_out[6:0], stage2_out[7]} : stage2_out;

endmodule