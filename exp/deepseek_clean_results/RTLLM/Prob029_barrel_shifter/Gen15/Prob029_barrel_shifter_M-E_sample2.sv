module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Precompute all possible single shifts
    wire [7:0] shift1 = {in[0], in[7:1]};      // 1-bit rotation
    wire [7:0] shift2 = {in[1:0], in[7:2]};    // 2-bit rotation
    wire [7:0] shift4 = {in[3:0], in[7:4]};    // 4-bit rotation
    
    // First level: select between 0, 1, 2, or 4 bit shifts
    wire [7:0] level1;
    assign level1 = (ctrl[1:0] == 2'b00) ? in :
                   (ctrl[1:0] == 2'b01) ? shift1 :
                   (ctrl[1:0] == 2'b10) ? shift2 : shift4;
    
    // Second level: apply additional 4-bit shift if needed
    wire [7:0] level2 = ctrl[2] ? {level1[3:0], level1[7:4]} : level1;
    
    // Final output
    assign out = level2;
endmodule