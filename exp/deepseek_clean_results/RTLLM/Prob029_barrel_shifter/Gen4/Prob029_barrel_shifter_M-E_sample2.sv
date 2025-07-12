module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Individual shift operations
    wire [7:0] shift4 = {in[3:0], in[7:4]};  // 4-bit rotate
    wire [7:0] shift2 = {in[5:0], in[7:6]};  // 2-bit rotate
    wire [7:0] shift1 = {in[6:0], in[7]};    // 1-bit rotate
    
    // Hierarchical selection
    wire [7:0] stage1 = ctrl[2] ? shift4 : in;
    wire [7:0] stage2 = ctrl[1] ? shift2 : stage1;
    wire [7:0] stage3 = ctrl[0] ? shift1 : stage2;
    
    assign out = stage3;
endmodule