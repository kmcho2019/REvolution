// Define the mux2X1 module
module mux2X1(
    input [7:0] in0, in1,
    input sel,
    output [7:0] out
);
    assign out = (sel) ? in1 : in0;
endmodule

// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

    wire [7:0] shift4, shift2, shift1;

    // Shift by 4 positions
    assign shift4 = {in[3:0], 4'b0000};

    // Shift by 2 positions
    assign shift2 = {in[5:0], 2'b00};

    // Shift by 1 position
    assign shift1 = {in[6:0], 1'b0};

    // Stage 1: Shift by 4 positions
    mux2X1 stage1 mux2X1_1 (.in0(in), .in1(shift4), .sel(ctrl[2]), .out(shift4_out));
    wire [7:0] shift4_out;

    // Stage 2: Shift by 2 positions
    mux2X1 stage2 mux2X1_2 (.in0(shift4_out), .in1(shift2), .sel(ctrl[1]), .out(shift2_out));
    wire [7:0] shift2_out;

    // Stage 3: Shift by 1 position
    mux2X1 stage3 mux2X1_3 (.in0(shift2_out), .in1(shift1), .sel(ctrl[0]), .out(out));
endmodule