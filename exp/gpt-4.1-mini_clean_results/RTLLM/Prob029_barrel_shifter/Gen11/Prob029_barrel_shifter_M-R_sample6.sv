module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    wire [7:0] stage0_out, stage1_out;

    // Stage 0: rotate by 4 bits if ctrl[2] == 1
    // For each bit i, select in[i] or in[(i+4)%8]
    assign stage0_out = ctrl[2] ? 
                        {in[3:0], in[7:4]} : 
                        in;

    // Stage 1: rotate by 2 bits if ctrl[1] == 1
    // For each bit i, select stage0_out[i] or stage0_out[(i+2)%8]
    assign stage1_out = ctrl[1] ? 
                        {stage0_out[5:0], stage0_out[7:6]} : 
                        stage0_out;

    // Stage 2: rotate by 1 bit if ctrl[0] == 1
    // For each bit i, select stage1_out[i] or stage1_out[(i+1)%8]
    assign out = ctrl[0] ? 
                 {stage1_out[6:0], stage1_out[7]} : 
                 stage1_out;

endmodule