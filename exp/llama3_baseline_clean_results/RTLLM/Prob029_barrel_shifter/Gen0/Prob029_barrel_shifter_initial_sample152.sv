// Define a 2-to-1 multiplexer submodule
module mux2X1(in0, in1, sel, out);
    input [7:0] in0, in1;
    input       sel;
    output [7:0] out;
    
    assign out = (sel) ? in1 : in0;
endmodule

// Define the barrel shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;
    
    // First stage: shift by 4 positions if ctrl[2] is high
    wire [7:0] shift4, shift4_out;
    assign shift4 = {in[3:0], 4'b0000};
    mux2X1 in_shift4_m( .in0(in), .in1(shift4), .sel(ctrl[2]), .out(shift4_out));
    
    // Second stage: shift by 2 positions if ctrl[1] is high
    wire [7:0] shift2, shift2_out;
    assign shift2 = {in[5:0], 2'b00};
    mux2X1 shift4_shift2_m( .in0(shift4_out), .in1(shift2), .sel(ctrl[1]), .out(shift2_out));
    
    // Third stage: shift by 1 position if ctrl[0] is high
    wire [7:0] shift1;
    assign shift1 = {in[6:0], 1'b0};
    mux2X1 shift2_shift1_m( .in0(shift2_out), .in1(shift1), .sel(ctrl[0]), .out(out));
endmodule