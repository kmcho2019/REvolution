module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

    // Intermediate signals for each shift stage
    wire [7:0] shift4 = {in[3:0], in[7:4]};  // 4-bit right rotation
    wire [7:0] shift2 = {in[1:0], in[7:2]};  // 2-bit right rotation
    wire [7:0] shift1 = {in[0], in[7:1]};    // 1-bit right rotation

    // Stage outputs with conditional shifting
    wire [7:0] after_stage4 = ctrl[2] ? shift4 : in;
    wire [7:0] after_stage2 = ctrl[1] ? {after_stage4[1:0], after_stage4[7:2]} : after_stage4;
    wire [7:0] after_stage1 = ctrl[0] ? {after_stage2[0], after_stage2[7:1]} : after_stage2;

    // Final output assignment
    assign out = after_stage1;

endmodule