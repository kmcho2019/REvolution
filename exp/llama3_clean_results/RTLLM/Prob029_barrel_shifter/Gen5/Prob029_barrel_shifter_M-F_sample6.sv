module barrel_shifter(
    input [7:0] in, 
    input [2:0] ctrl, 
    output [7:0] out
);

    // Shift by 4 positions
    wire [7:0] shift4 = {in[3:0], in[7:4]};
    
    // Shift by 2 positions
    wire [7:0] shift2;
    wire [7:0] after_shift4;
    
    // Assign after_shift4 based on ctrl[2]
    assign after_shift4 = (ctrl[2])? shift4 : in;
    
    // Shift after_shift4 by 2 positions if ctrl[1] is high
    assign shift2 = (ctrl[1])? {after_shift4[1:0], after_shift4[7:2]} : after_shift4;
    
    // Intermediate result after shifting by 2 positions if ctrl[1] is high
    wire [7:0] after_shift2 = shift2;
    
    // Shift after_shift2 by 1 position if ctrl[0] is high
    assign out = (ctrl[0])? {after_shift2[0], after_shift2[7:1]} : after_shift2;

endmodule