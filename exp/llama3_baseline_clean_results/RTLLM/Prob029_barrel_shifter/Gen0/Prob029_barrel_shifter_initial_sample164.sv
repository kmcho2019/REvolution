// Define the mux2X1 submodule
module mux2X1(out, a, b, sel);
    output [7:0] out;
    input [7:0] a, b;
    input sel;

    assign out = (sel) ? b : a;
endmodule

// Define the barrel shifter module
module barrel_shifter(out, in, ctrl);
    output [7:0] out;
    input [7:0] in;
    input [2:0] ctrl;

    // Intermediate wires for each stage
    wire [7:0] stage1_out, stage2_out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 stage1_mux1(out, in, {in[3:0], 4'b0000}, ctrl[2]);
    mux2X1 stage1_mux2(out, in, {4'b0000, in[7:4]}, ctrl[2]);
    mux2X1 stage1_mux3(out, in, {in[7:4], in[3:0]}, ~ctrl[2]);
    mux2X1 stage1_mux4(out, stage1_mux1.out, stage1_mux2.out, ~ctrl[2]);
    assign stage1_out = (ctrl[2]) ? {in[3:0], 4'b0000} : in;

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 stage2_mux1(stage2_out, stage1_out, {stage1_out[6:0], stage1_out[7]}, ctrl[1]);
    assign stage2_out = (ctrl[1]) ? {stage1_out[6:0], stage1_out[7]} : stage1_out;

    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 final_mux(out, stage2_out, {stage2_out[7:1], stage2_out[0]}, ctrl[0]);
    assign out = (ctrl[0]) ? {stage2_out[7:1], stage2_out[0]} : stage2_out;
endmodule