// Define the submodule mux2X1
module mux2X1(
    input  [7:0] in0,
    input  [7:0] in1,
    input        sel,
    output [7:0] out
);

    assign out = sel? in1 : in0;

endmodule

// Define the barrel shifter module
module barrel_shifter(
    input  [7:0] in,
    input  [2:0] ctrl,
    output [7:0] out
);

    // First stage: shift by 4 positions if ctrl[2] is high
    wire [7:0] stage1_out;
    mux2X1 stage1(
       .in0(in),  // original input
       .in1({in[3:0], 4'b0000}),  // input shifted by 4 positions
       .sel(ctrl[2]),
       .out(stage1_out)
    );

    // Second stage: shift by 2 positions if ctrl[1] is high
    wire [7:0] stage2_out;
    mux2X1 stage2(
       .in0(stage1_out),  // output of first stage
       .in1({stage1_out[5:0], 2'b00}),  // output of first stage shifted by 2 positions
       .sel(ctrl[1]),
       .out(stage2_out)
    );

    // Third stage: shift by 1 position if ctrl[0] is high
    wire [7:0] stage3_out;
    mux2X1 stage3(
       .in0(stage2_out),  // output of second stage
       .in1({stage2_out[6:0], 1'b0}),  // output of second stage shifted by 1 position
       .sel(ctrl[0]),
       .out(stage3_out)
    );

    // Assign the output of the last stage to the out port
    assign out = stage3_out;

endmodule