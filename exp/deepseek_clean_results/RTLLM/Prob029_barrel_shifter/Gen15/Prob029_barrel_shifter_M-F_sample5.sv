module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    wire [7:0] stage1_out;
    wire [7:0] stage2_out;
    
    // Stage 1: Shift by 4 if ctrl[2] is set
    assign stage1_out = ctrl[2] ? {in[3:0], in[7:4]} : in;
    
    // Stage 2: Shift by 2 if ctrl[1] is set
    assign stage2_out = ctrl[1] ? {stage1_out[1:0], stage1_out[7:2]} : stage1_out;
    
    // Stage 3: Shift by 1 if ctrl[0] is set
    assign out = ctrl[0] ? {stage2_out[0], stage2_out[7:1]} : stage2_out;
endmodule