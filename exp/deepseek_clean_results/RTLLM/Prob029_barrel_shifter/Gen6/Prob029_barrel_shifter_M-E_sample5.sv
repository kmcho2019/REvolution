module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,  // ctrl[2]: direction (0=left, 1=right), ctrl[1:0]: shift amount (0-3)
    output [7:0] out
);

wire [7:0] stage1_out;
wire [7:0] stage2_out;

// Stage 1: Rotate by 4 if ctrl[1] is set (for left/right)
assign stage1_out = ctrl[1] ? 
                   (ctrl[2] ? {in[3:0], in[7:4]} : {in[7:4], in[3:0]}) : 
                   in;

// Stage 2: Rotate by 2 if ctrl[0] is set (for left/right)
assign stage2_out = ctrl[0] ?
                   (ctrl[2] ? {stage1_out[1:0], stage1_out[7:2]} : {stage1_out[5:0], stage1_out[7:6]}) :
                   stage1_out;

// Final stage: Rotate by 1 if ctrl[0] is set (for left/right)
assign out = ctrl[0] ?
            (ctrl[2] ? {stage2_out[0], stage2_out[7:1]} : {stage2_out[6:0], stage2_out[7]}) :
            stage2_out;

endmodule