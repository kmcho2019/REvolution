// Define the submodule mux2X1
module mux2X1 (
    input [7:0] in0,
    input [7:0] in1,
    input sel,
    output [7:0] out
);

    assign out = (sel == 1'b1)? in1 : in0;

endmodule

// Define the barrel_shifter module
module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

    // Stage 1: Shift by 4 positions
    wire [7:0] shift4;
    assign shift4 = {in[3:0], 4'b0000};

    // Stage 2: Shift by 2 positions
    wire [7:0] shift2;
    assign shift2 = {in[5:0], 2'b00};

    // Stage 3: Shift by 1 position
    wire [7:0] shift1;
    assign shift1 = {in[6:0], 1'b0};

    // Instantiate the mux2X1 submodule for each stage
    wire [7:0] stage1_out;
    mux2X1 stage1_mux (
       .in0(in),
       .in1(shift4),
       .sel(ctrl[2]),
       .out(stage1_out)
    );

    wire [7:0] stage2_out;
    mux2X1 stage2_mux (
       .in0(stage1_out),
       .in1(shift2),
       .sel(ctrl[1]),
       .out(stage2_out)
    );

    wire [7:0] stage3_out;
    mux2X1 stage3_mux (
       .in0(stage2_out),
       .in1(shift1),
       .sel(ctrl[0]),
       .out(stage3_out)
    );

    // Assign the final output
    assign out = stage3_out;

endmodule