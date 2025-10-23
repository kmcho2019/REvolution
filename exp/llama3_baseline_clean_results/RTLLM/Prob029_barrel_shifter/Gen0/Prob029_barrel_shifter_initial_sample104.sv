// Define the mux2X1 submodule
module mux2X1(sel, in0, in1, out);
    input sel;
    input [7:0] in0, in1;
    output [7:0] out;

    assign out = (sel == 1'b1) ? in1 : in0;
endmodule

// Define the barrel_shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // Stage 1: Shift by 4 positions based on ctrl[2]
    wire [7:0] stage1_out;
    mux2X1 u1(ctrl[2], in, {in[3:0], 4'b0000}, stage1_out);

    // Stage 2: Shift by 2 positions based on ctrl[1]
    wire [7:0] stage2_out;
    mux2X1 u2(ctrl[1], stage1_out, {stage1_out[5:0], 2'b00}, stage2_out);

    // Stage 3: Shift by 1 position based on ctrl[0]
    mux2X1 u3(ctrl[0], stage2_out, {stage2_out[6:0], 1'b0}, out);
endmodule