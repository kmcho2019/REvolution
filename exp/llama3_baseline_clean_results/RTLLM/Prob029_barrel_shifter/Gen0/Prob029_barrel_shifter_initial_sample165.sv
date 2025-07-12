// Define the submodule mux2X1
module mux2X1 #(parameter WIDTH = 8) (
    input  [WIDTH-1:0] in0, in1, // two input values
    input              sel,    // select signal
    output [WIDTH-1:0] out     // output value
);

    assign out = sel ? in1 : in0;

endmodule

// Define the barrel_shifter module
module barrel_shifter (
    input  [7:0] in,  // 8-bit input to be shifted
    input  [2:0] ctrl, // 3-bit control signal
    output [7:0] out  // 8-bit shifted output
);

    // Define the intermediate signals for each stage of shifting
    wire [7:0] shift_4, shift_2, shift_1;

    // Stage 1: Shift by 4 positions
    mux2X1 #(.WIDTH(8)) mux_shift_4 (
        .in0(in),        // original input
        .in1({in[3:0], 4'b0000}), // input shifted by 4 positions
        .sel(ctrl[2]),   // select signal
        .out(shift_4)    // output of this stage
    );

    // Stage 2: Shift by 2 positions
    mux2X1 #(.WIDTH(8)) mux_shift_2 (
        .in0(shift_4),   // input from previous stage
        .in1({shift_4[5:0], 2'b00}), // input shifted by 2 positions
        .sel(ctrl[1]),   // select signal
        .out(shift_2)    // output of this stage
    );

    // Stage 3: Shift by 1 position
    mux2X1 #(.WIDTH(8)) mux_shift_1 (
        .in0(shift_2),   // input from previous stage
        .in1({shift_2[6:0], 1'b0}), // input shifted by 1 position
        .sel(ctrl[0]),   // select signal
        .out(out)       // final output
    );

endmodule