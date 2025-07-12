module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Intermediate results after each potential shift stage
    wire [7:0] stage4 = ctrl[2] ? {in[3:0], in[7:4]} : in;
    wire [7:0] stage2 = ctrl[1] ? {stage4[1:0], stage4[7:2]} : stage4;
    wire [7:0] stage1 = ctrl[0] ? {stage2[0], stage2[7:1]} : stage2;
    
    // Final output after all enabled shifts
    assign out = stage1;
endmodule