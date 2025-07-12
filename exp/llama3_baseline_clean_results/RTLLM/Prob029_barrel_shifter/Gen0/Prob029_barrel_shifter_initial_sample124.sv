// Define the 2-to-1 multiplexer submodule
module mux2X1(
    input  wire [7:0] in0,  // First input
    input  wire [7:0] in1,  // Second input
    input  wire         sel,  // Select signal
    output wire [7:0] out   // Output
);

    assign out = sel ? in1 : in0;

endmodule

// Define the barrel shifter module
module barrel_shifter(
    input  wire [7:0] in,  // 8-bit input to be shifted
    input  wire [2:0] ctrl,  // 3-bit control signal
    output wire [7:0] out  // 8-bit shifted output
);

    // First stage: shift by 4 positions
    wire [7:0] stage1_in0, stage1_in1, stage1_out;
    assign stage1_in0 = in;  // Original input
    assign stage1_in1 = {in[3:0], in[7:4]};  // Input shifted by 4 positions

    mux2X1 stage1_mux(
        .in0(stage1_in0),
        .in1(stage1_in1),
        .sel(ctrl[2]),
        .out(stage1_out)
    );

    // Second stage: shift by 2 positions
    wire [7:0] stage2_in0, stage2_in1, stage2_out;
    assign stage2_in0 = stage1_out;  // Input from previous stage
    assign stage2_in1 = {stage1_out[5:0], stage1_out[7:6]};  // Input shifted by 2 positions

    mux2X1 stage2_mux(
        .in0(stage2_in0),
        .in1(stage2_in1),
        .sel(ctrl[1]),
        .out(stage2_out)
    );

    // Third stage: shift by 1 position
    wire [7:0] stage3_in0, stage3_in1, stage3_out;
    assign stage3_in0 = stage2_out;  // Input from previous stage
    assign stage3_in1 = {stage2_out[6:0], stage2_out[7]};  // Input shifted by 1 position

    mux2X1 stage3_mux(
        .in0(stage3_in0),
        .in1(stage3_in1),
        .sel(ctrl[0]),
        .out(stage3_out)
    );

    // Final output
    assign out = stage3_out;

endmodule