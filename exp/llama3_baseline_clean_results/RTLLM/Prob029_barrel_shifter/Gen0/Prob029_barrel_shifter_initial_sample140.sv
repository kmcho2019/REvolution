// Define the mux2X1 submodule for selecting between two inputs
module mux2X1(
    input [7:0] in0,  // First input
    input [7:0] in1,  // Second input
    input sel,       // Select signal
    output [7:0] out  // Output
);
    // Use the select signal to choose between in0 and in1
    assign out = (sel == 1'b1) ? in1 : in0;
endmodule

// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,  // 8-bit input to be shifted
    input [2:0] ctrl,  // 3-bit control signal
    output [7:0] out  // 8-bit shifted output
);
    // Stage 1: Shift by 4 positions if ctrl[2] is high
    wire [7:0] stage1_shifted;
    assign stage1_shifted = {in[3:0], 4'b0000};  // Shift in by 4 positions
    wire [7:0] stage1_out;
    mux2X1 stage1_mux(in, stage1_shifted, ctrl[2], stage1_out);

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    wire [7:0] stage2_shifted;
    assign stage2_shifted = {stage1_out[5:0], 2'b00};  // Shift stage1_out by 2 positions
    wire [7:0] stage2_out;
    mux2X1 stage2_mux(stage1_out, stage2_shifted, ctrl[1], stage2_out);

    // Stage 3: Shift by 1 position if ctrl[0] is high
    wire [7:0] stage3_shifted;
    assign stage3_shifted = {stage2_out[6:0], 1'b0};  // Shift stage2_out by 1 position
    mux2X1 stage3_mux(stage2_out, stage3_shifted, ctrl[0], out);
endmodule