module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Generate all possible shifted versions in parallel
    wire [7:0] shift4 = {in[3:0], in[7:4]};  // Shift by 4
    wire [7:0] shift2 = {in[1:0], in[7:2]};  // Shift by 2
    wire [7:0] shift1 = {in[0], in[7:1]};    // Shift by 1
    
    // First selection level: choose between original or shift4
    wire [7:0] level1 = ctrl[2] ? shift4 : in;
    
    // Second selection level: choose between level1 or level1 shifted by 2
    wire [7:0] level2 = ctrl[1] ? {level1[1:0], level1[7:2]} : level1;
    
    // Final selection level: choose between level2 or level2 shifted by 1
    assign out = ctrl[0] ? {level2[0], level2[7:1]} : level2;
endmodule