module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    input dir,          // 0=right, 1=left
    output [7:0] out
);
    wire [7:0] stage1, stage2;

    // Stage 1: 4-bit rotation
    assign stage1 = ctrl[2] ? 
                  (dir ? {in[3:0], in[7:4]} : {in[7:4], in[3:0]}) : 
                  in;

    // Stage 2: 2-bit rotation
    assign stage2 = ctrl[1] ?
                  (dir ? {stage1[1:0], stage1[7:2]} : {stage1[5:0], stage1[7:6]}) :
                  stage1;

    // Stage 3: 1-bit rotation
    assign out = ctrl[0] ?
               (dir ? {stage2[0], stage2[7:1]} : {stage2[6:0], stage2[7]}) :
               stage2;
endmodule