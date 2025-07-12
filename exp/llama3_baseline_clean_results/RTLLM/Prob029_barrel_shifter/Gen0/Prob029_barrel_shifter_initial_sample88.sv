// Define the 2-to-1 multiplexer submodule
module mux2X1(sel, a, b, out);
    input sel;
    input [7:0] a, b;
    output [7:0] out;
    
    assign out = (sel) ? b : a;
endmodule

// Define the barrel shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;
    
    // Declare internal wires
    wire [7:0] shifted_by_4, shifted_by_2, shifted_by_1;
    
    // First stage: Shift by 4 positions
    mux2X1 mux_by_4(ctrl[2], in, {in[3:0], 4'b0000}, shifted_by_4);
    
    // Second stage: Shift by 2 positions
    mux2X1 mux_by_2(ctrl[1], shifted_by_4, {shifted_by_4[5:0], 2'b00}, shifted_by_2);
    
    // Third stage: Shift by 1 position
    mux2X1 mux_by_1(ctrl[0], shifted_by_2, {shifted_by_2[6:0], 1'b0}, shifted_by_1);
    
    // Assign the final output
    assign out = shifted_by_1;
endmodule