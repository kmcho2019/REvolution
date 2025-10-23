// Define the mux2X1 submodule
module mux2X1(a, b, sel, out);
    input [7:0] a, b;
    input sel;
    output [7:0] out;
    
    assign out = (sel) ? b : a;
endmodule

// Define the barrel shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;
    
    // Define wires for intermediate results
    wire [7:0] shift4, shift2, shift1;
    
    // Shift by 4 positions if ctrl[2] is high
    mux2X1 in, {in[3:0], 4'b0000}, ctrl[2], shift4;
    
    // Shift by 2 positions if ctrl[1] is high
    mux2X1 shift4, {shift4[5:0], 2'b00}, ctrl[1], shift2;
    
    // Shift by 1 position if ctrl[0] is high
    mux2X1 shift2, {shift2[6:0], 1'b0}, ctrl[0], shift1;
    
    // Assign the final output
    assign out = shift1;
endmodule