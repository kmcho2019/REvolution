// Define the mux2X1 submodule
module mux2X1(
    input  [7:0] in0, in1,
    input         sel,
    output [7:0] out
);
    assign out = (sel == 1'b1) ? in1 : in0;
endmodule

// Define the barrel_shifter module
module barrel_shifter(
    input  [7:0] in,
    input  [2:0] ctrl,
    output [7:0] out
);

    // Stage 1: Shift by 4 positions
    wire [7:0] stage1_in0, stage1_in1;
    assign stage1_in0 = in;
    assign stage1_in1 = {in[3:0], 4'b0000};
    wire [7:0] stage1_out;
    mux2X1 stage1_mux(in0, stage1_in0, in1, stage1_in1, sel, ctrl[2], stage1_out);

    // Stage 2: Shift by 2 positions
    wire [7:0] stage2_in0, stage2_in1;
    assign stage2_in0 = stage1_out;
    assign stage2_in1 = {stage1_out[5:0], 2'b00};
    wire [7:0] stage2_out;
    mux2X1 stage2_mux(in0, stage2_in0, in1, stage2_in1, sel, ctrl[1], stage2_out);

    // Stage 3: Shift by 1 position
    wire [7:0] stage3_in0, stage3_in1;
    assign stage3_in0 = stage2_out;
    assign stage3_in1 = {stage2_out[6:0], 1'b0};
    assign out = (ctrl[0] == 1'b1) ? stage3_in1 : stage3_in0;

endmodule