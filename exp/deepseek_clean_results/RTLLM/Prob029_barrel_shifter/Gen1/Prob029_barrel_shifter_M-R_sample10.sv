module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    wire [7:0] stage1_out = ctrl[2] ? {in[3:0], in[7:4]} : in;
    wire [7:0] stage2_out = ctrl[1] ? {stage1_out[1:0], stage1_out[7:2]} : stage1_out;
    assign out = ctrl[0] ? {stage2_out[0], stage2_out[7:1]} : stage2_out;
endmodule