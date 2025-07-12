// Define the mux2X1 submodule
module mux2X1(out, sel, in0, in1);
    output [7:0] out;
    input [7:0] in0, in1;
    input sel;

    assign out = (sel) ? in1 : in0;
endmodule

// Define the barrel_shifter module
module barrel_shifter(out, in, ctrl);
    output [7:0] out;
    input [7:0] in;
    input [2:0] ctrl;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    wire [7:0] stage1_out;
    mux2X1 stage1_m1(stage1_out, ctrl[2], in, {in[3:0], in[7:4]});

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    wire [7:0] stage2_out;
    mux2X1 stage2_m1(stage2_out, ctrl[1], stage1_out, {stage1_out[1:0], stage1_out[7:2]});

    // Stage 3: Shift by 1 position if ctrl[0] is high
    wire [7:0] stage3_out;
    mux2X1 stage3_m1(stage3_out, ctrl[0], stage2_out, {stage2_out[0], stage2_out[7:1]});

    // Final output
    assign out = stage3_out;
endmodule