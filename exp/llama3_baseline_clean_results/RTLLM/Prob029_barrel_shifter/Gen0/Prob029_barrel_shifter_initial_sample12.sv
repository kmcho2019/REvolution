// Define the mux2X1 submodule
module mux2X1(out, in1, in2, sel);
    output [7:0] out;
    input  [7:0] in1, in2;
    input        sel;

    assign out = sel ? in2 : in1;
endmodule

// Define the barrel_shifter module
module barrel_shifter(out, in, ctrl);
    output [7:0] out;
    input  [7:0] in;
    input  [2:0] ctrl;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    wire [7:0] stage1_in1, stage1_in2, stage1_out;
    assign stage1_in1 = in;
    assign stage1_in2 = {in[3:0], in[7:4]}; // Rotate right by 4
    mux2X1 stage1_mux(out[7:0], stage1_in1, stage1_in2, ctrl[2]);

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    wire [7:0] stage2_in1, stage2_in2, stage2_out;
    assign stage2_in1 = stage1_out;
    assign stage2_in2 = {stage1_out[6:0], stage1_out[7]}; // Rotate right by 2
    mux2X1 stage2_mux(stage2_out, stage2_in1, stage2_in2, ctrl[1]);

    // Stage 3: Shift by 1 position if ctrl[0] is high
    wire [7:0] stage3_in1, stage3_in2;
    assign stage3_in1 = stage2_out;
    assign stage3_in2 = {stage2_out[6:0], stage2_out[7]}; // Rotate right by 1
    mux2X1 stage3_mux(out, stage3_in1, stage3_in2, ctrl[0]);
endmodule