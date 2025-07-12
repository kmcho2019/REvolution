// Define the mux2X1 submodule
module mux2X1(sel, in0, in1, out);
    input sel;
    input [7:0] in0, in1;
    output [7:0] out;
    
    assign out = (sel) ? in1 : in0;
endmodule

// Define the barrel_shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;
    
    // Define internal wires
    wire [7:0] shift4, shift2, shift1;
    
    // Shift by 4 positions
    mux2X1 mux4(ctrl[2], in, {in[3:0], 4'b0000}, shift4);
    
    // Shift by 2 positions
    mux2X1 mux2(ctrl[1], shift4, {shift4[5:0], 2'b00}, shift2);
    
    // Shift by 1 position
    mux2X1 mux1(ctrl[0], shift2, {shift2[6:0], 1'b0}, shift1);
    
    // Assign the final output
    assign out = shift1;
endmodule