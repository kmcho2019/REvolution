// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,   // 8-bit input to be shifted
    input [2:0] ctrl, // 3-bit control signal
    output [7:0] out   // 8-bit shifted output
);

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    wire [7:0] stage1;
    assign stage1 = (ctrl[2] == 1'b1) ? {in[3:0], in[7:4]} : in;

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    wire [7:0] stage2;
    assign stage2 = (ctrl[1] == 1'b1) ? {stage1[5:0], stage1[7:6]} : stage1;

    // Stage 3: Shift by 1 position if ctrl[0] is high
    wire [7:0] stage3;
    assign stage3 = (ctrl[0] == 1'b1) ? {stage2[6:0], stage2[7]} : stage2;

    // Assign the final output
    assign out = stage3;

endmodule