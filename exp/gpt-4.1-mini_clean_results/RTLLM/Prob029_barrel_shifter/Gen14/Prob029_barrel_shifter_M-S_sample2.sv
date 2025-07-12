module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    wire [7:0] stage1;
    wire [7:0] stage2;

    // Rotate left by 4 if ctrl[2] set, else pass through
    assign stage1 = ctrl[2] ? {in[3:0], in[7:4]} : in;

    // Rotate left by 2 if ctrl[1] set, else pass through
    assign stage2 = ctrl[1] ? {stage1[5:0], stage1[7:6]} : stage1;

    // Rotate left by 1 if ctrl[0] set, else pass through
    assign out = ctrl[0] ? {stage2[6:0], stage2[7]} : stage2;

endmodule