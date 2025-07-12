// Define a submodule for 2-to-1 multiplexer
module mux2X1(
    input   [7:0] in0,  // First input
    input   [7:0] in1,  // Second input
    input         sel, // Select signal
    output  [7:0] out  // Output
);

    assign out = (sel) ? in1 : in0;

endmodule

// Define the barrel shifter module
module barrel_shifter(
    input   [7:0] in,   // 8-bit input to be shifted
    input   [2:0] ctrl, // 3-bit control signal
    output  [7:0] out   // 8-bit shifted output
);

    // Stage 1: Shift by 4 positions
    wire    [7:0] stage1_in0;
    wire    [7:0] stage1_in1;
    wire    [7:0] stage1_out;

    assign stage1_in0 = in; // No shift
    assign stage1_in1 = {in[3:0], in[7:4]}; // Shift by 4 positions

    mux2X1 stage1_mux(
        .in0(stage1_in0),
        .in1(stage1_in1),
        .sel(ctrl[2]),
        .out(stage1_out)
    );

    // Stage 2: Shift by 2 positions
    wire    [7:0] stage2_in0;
    wire    [7:0] stage2_in1;
    wire    [7:0] stage2_out;

    assign stage2_in0 = stage1_out; // No shift
    assign stage2_in1 = {stage1_out[5:0], stage1_out[7:6]}; // Shift by 2 positions

    mux2X1 stage2_mux(
        .in0(stage2_in0),
        .in1(stage2_in1),
        .sel(ctrl[1]),
        .out(stage2_out)
    );

    // Stage 3: Shift by 1 position
    wire    [7:0] stage3_in0;
    wire    [7:0] stage3_in1;
    wire    [7:0] stage3_out;

    assign stage3_in0 = stage2_out; // No shift
    assign stage3_in1 = {stage2_out[6:0], stage2_out[7]}; // Shift by 1 position

    mux2X1 stage3_mux(
        .in0(stage3_in0),
        .in1(stage3_in1),
        .sel(ctrl[0]),
        .out(stage3_out)
    );

    assign out = stage3_out;

endmodule