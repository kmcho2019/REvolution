// Define the submodule mux2X1
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

    // Intermediate signals
    wire [7:0] shift_by_4;
    wire [7:0] shift_by_2;
    wire [7:0] shift_by_1;

    // Shift by 4 positions
    assign shift_by_4 = {in[3:0], 4'b0000};

    // Use mux2X1 to select between original input and shifted input
    mux2X1 mux_by_4(ctrl[2], in, shift_by_4, shift_by_2);

    // Shift by 2 positions
    assign shift_by_1 = {in[5:0], 2'b00};

    // Use mux2X1 to select between result from previous stage and shifted result
    mux2X1 mux_by_2(ctrl[1], shift_by_2, shift_by_1, shift_by_1);

    // Shift by 1 position
    assign out = {in[6:0], 1'b0};

    // Use mux2X1 to select between result from previous stage and final shifted result
    mux2X1 mux_by_1(ctrl[0], shift_by_1, out, out);
endmodule