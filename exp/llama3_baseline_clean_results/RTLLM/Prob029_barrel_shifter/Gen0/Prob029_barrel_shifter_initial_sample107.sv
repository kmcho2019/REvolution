// mux2X1 submodule
module mux2X1(
    input  [7:0] in0, in1,  // 8-bit inputs
    input         sel,     // select signal
    output [7:0] out       // 8-bit output
);

    assign out = (sel == 1'b1) ? in1 : in0;

endmodule

// barrel_shifter module
module barrel_shifter(
    input  [7:0] in,       // 8-bit input
    input  [2:0] ctrl,     // 3-bit control signal
    output [7:0] out       // 8-bit shifted output
);

    // Internal signals for intermediate results
    wire [7:0] shift4, shift2, shift1;

    // Shift by 4 positions
    mux2X1 shift_4(
        .in0(in), 
        .in1({in[3:0], 4'b0000}), 
        .sel(ctrl[2]), 
        .out(shift4)
    );

    // Shift by 2 positions
    mux2X1 shift_2(
        .in0(shift4), 
        .in1({shift4[5:0], 2'b00}), 
        .sel(ctrl[1]), 
        .out(shift2)
    );

    // Shift by 1 position
    mux2X1 shift_1(
        .in0(shift2), 
        .in1({shift2[6:0], 1'b0}), 
        .sel(ctrl[0]), 
        .out(shift1)
    );

    // Final output
    assign out = shift1;

endmodule