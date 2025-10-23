module barrel_shifter(
    input [7:0] in, 
    input [2:0] ctrl, 
    output [7:0] out
);

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    wire [7:0] after_shift4 = (ctrl[2])? {in[3:0], in[7:4]} : in;
    
    // Stage 2: Shift by 2 positions if ctrl[1] is high
    wire [7:0] after_shift2 = (ctrl[1])? {after_shift4[1:0], after_shift4[7:2]} : after_shift4;
    
    // Stage 3: Shift by 1 position if ctrl[0] is high
    assign out = (ctrl[0])? {after_shift2[0], after_shift2[7:1]} : after_shift2;

endmodule