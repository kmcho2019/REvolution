module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Define each possible shift operation
    wire [7:0] shift_4 = {in[3:0], in[7:4]};  // Right rotate by 4
    wire [7:0] shift_2 = {in[1:0], in[7:2]};  // Right rotate by 2
    wire [7:0] shift_1 = {in[0],   in[7:1]};  // Right rotate by 1
    
    // Apply shifts in order of magnitude (4, 2, 1)
    wire [7:0] stage1 = ctrl[2] ? shift_4 : in;
    wire [7:0] stage2 = ctrl[1] ? {stage1[1:0], stage1[7:2]} : stage1;
    
    // Final output assignment
    assign out = ctrl[0] ? {stage2[0], stage2[7:1]} : stage2;
endmodule