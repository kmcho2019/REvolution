module barrel_shifter(
    input [7:0] in, 
    input [2:0] ctrl, 
    output [7:0] out
);

    // Define intermediate results for each stage of shifting
    wire [7:0] shift4, shift2, shift1;

    // Shift by 4 positions if ctrl[2] is high
    assign shift4 = (ctrl[2]) ? {in[3:0], in[7:4]} : in;

    // Shift the result by 2 positions if ctrl[1] is high
    assign shift2 = (ctrl[1]) ? {shift4[5:0], shift4[7:6]} : shift4;

    // Shift the result by 1 position if ctrl[0] is high
    assign shift1 = (ctrl[0]) ? {shift2[6:0], shift2[7]} : shift2;

    // Assign the final output based on the intermediate results
    assign out = shift1;

endmodule