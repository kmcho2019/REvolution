module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    // Stage 1: rotate by 4 if ctrl[2] == 1, else pass input
    wire [7:0] stage1 = ctrl[2] ? 
        {in[3:0], in[7:4]} : in;

    // Stage 2: rotate by 2 if ctrl[1] == 1, else pass stage1
    wire [7:0] stage2 = ctrl[1] ? 
        {stage1[5:0], stage1[7:6]} : stage1;

    // Stage 3: rotate by 1 if ctrl[0] == 1, else pass stage2
    assign out = ctrl[0] ? 
        {stage2[6:0], stage2[7]} : stage2;

endmodule