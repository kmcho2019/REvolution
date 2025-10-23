module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

    // Internal shift results
    wire [7:0] shift1, shift2, shift4;
    
    // 1-bit right rotation
    assign shift1 = {in[0], in[7:1]};
    
    // 2-bit right rotation
    assign shift2 = {in[1:0], in[7:2]};
    
    // 4-bit right rotation
    assign shift4 = {in[3:0], in[7:4]};
    
    // Final output selection
    assign out = (ctrl[0] ? shift1 : in) |
                 (ctrl[1] ? shift2 : 8'b0) |
                 (ctrl[2] ? shift4 : 8'b0);

endmodule