// Define the mux2X1 submodule
module mux2X1(out, in0, in1, sel);
    output [7:0] out;
    input [7:0] in0, in1;
    input sel;

    assign out = sel ? in1 : in0;
endmodule

// Define the barrel shifter module
module barrel_shifter(out, in, ctrl);
    output [7:0] out;
    input [7:0] in;
    input [2:0] ctrl;

    wire [7:0] stage1_out, stage2_out;

    // Stage 1: Shift by 4 positions
    mux2X1 stage1_mux(out, in, {in[3:0], 4'b0000}, ctrl[2]);
    assign stage1_out = stage1_mux.out;

    // Stage 2: Shift by 2 positions
    mux2X1 stage2_mux(out, stage1_out, {stage1_out[5:0], 2'b00}, ctrl[1]);
    assign stage2_out = stage2_mux.out;

    // Stage 3: Shift by 1 position
    mux2X1 stage3_mux(out, stage2_out, {stage2_out[6:0], 1'b0}, ctrl[0]);
endmodule