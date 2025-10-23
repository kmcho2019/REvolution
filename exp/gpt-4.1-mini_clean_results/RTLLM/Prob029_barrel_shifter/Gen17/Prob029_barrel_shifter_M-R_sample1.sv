module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // Stage 1: rotate left by 4 if ctrl[2], else pass input
    wire [7:0] stage1;
    assign stage1 = ctrl[2] ? 
                    {in[3:0], in[7:4]} :  // rotate left by 4
                    in;

    // Stage 2: rotate left by 2 if ctrl[1], else pass stage1
    wire [7:0] stage2;
    assign stage2 = ctrl[1] ? 
                    {stage1[5:0], stage1[7:6]} :  // rotate left by 2
                    stage1;

    // Stage 3: rotate left by 1 if ctrl[0], else pass stage2
    assign out = ctrl[0] ? 
                 {stage2[6:0], stage2[7]} :  // rotate left by 1
                 stage2;

endmodule