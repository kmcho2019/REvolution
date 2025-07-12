module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // Combine shifts by 4, 2, and 1 using bitwise concatenation and rotate left
    // The ctrl bits represent a shift amount from 0 to 7
    wire [7:0] stage1, stage2, stage3;

    // Shift by 4 if ctrl[2] is set
    assign stage1 = ctrl[2] ? {in[3:0], in[7:4]} : in;

    // Shift by 2 if ctrl[1] is set
    assign stage2 = ctrl[1] ? {stage1[5:0], stage1[7:6]} : stage1;

    // Shift by 1 if ctrl[0] is set
    assign stage3 = ctrl[0] ? {stage2[6:0], stage2[7]} : stage2;

    assign out = stage3;

endmodule