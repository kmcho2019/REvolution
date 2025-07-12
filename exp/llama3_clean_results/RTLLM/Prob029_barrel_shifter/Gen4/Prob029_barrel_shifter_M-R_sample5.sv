module barrel_shifter(
    input [7:0] in, 
    input [2:0] ctrl, 
    output [7:0] out
);

    // Shift by 4 positions
    wire [7:0] shift4 = {in[3:0], in[7:4]};
    
    // Shift by 2 positions
    wire [7:0] shift2 = {in[1:0], in[7:2]};
    
    // Shift by 1 position
    wire [7:0] shift1 = {in[0], in[7:1]};
    
    // Intermediate result after shifting by 4 positions if ctrl[2] is high
    wire [7:0] after_shift4 = (ctrl[2]) ? shift4 : in;
    
    // Intermediate result after shifting by 2 positions if ctrl[1] is high
    wire [7:0] after_shift2 = (ctrl[1]) ? shift2 : after_shift4;
    
    // Final output after shifting by 1 position if ctrl[0] is high
    assign out = (ctrl[0]) ? shift1 : after_shift2;

endmodule