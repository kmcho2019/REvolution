module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    wire [7:0] stage1 = ctrl[2] ? {in[3:0], in[7:4]} : in;
    wire [7:0] stage2 = ctrl[1] ? {stage1[5:0], stage1[7:6]} : stage1;
    wire [7:0] stage3 = ctrl[0] ? {stage2[6:0], stage2[7]} : stage2;

    assign out = stage3;

endmodule