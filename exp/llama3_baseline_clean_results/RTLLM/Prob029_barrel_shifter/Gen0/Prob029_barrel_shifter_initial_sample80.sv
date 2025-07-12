// mux2X1 submodule
module mux2X1 (
    input [7:0] in0, in1,  // two input signals
    input sel,             // select signal
    output [7:0] out       // output signal
);

assign out = (sel) ? in1 : in0;

endmodule

// barrel_shifter module
module barrel_shifter (
    input [7:0] in,        // 8-bit input
    input [2:0] ctrl,      // 3-bit control signal
    output [7:0] out       // 8-bit shifted output
);

// Intermediate wires for shifted inputs
wire [7:0] shift_by_4, shift_by_2, shift_by_1;

// First stage: shift by 4 positions if ctrl[2] is high
assign shift_by_4 = (ctrl[2]) ? {in[3:0], 4'b0000} : in;

// Second stage: shift by 2 positions if ctrl[1] is high
mux2X1 mux_by_2 (
    .in0(shift_by_4), 
    .in1({shift_by_4[5:0], 2'b00}), 
    .sel(ctrl[1]), 
    .out(shift_by_2)
);

// Third stage: shift by 1 position if ctrl[0] is high
mux2X1 mux_by_1 (
    .in0(shift_by_2), 
    .in1({shift_by_2[6:0], 1'b0}), 
    .sel(ctrl[0]), 
    .out(out)
);

endmodule