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

    // Declare internal wires for stage outputs
    wire [7:0] stage1_out, stage2_out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 #(.WIDTH(8)) stage1_mux(ctrl[2], in, {in[3:0], 4'b0000}, stage1_out);

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 #(.WIDTH(8)) stage2_mux(ctrl[1], stage1_out, {stage1_out[1:0], 6'b000000}, stage2_out);

    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 #(.WIDTH(8)) stage3_mux(ctrl[0], stage2_out, {stage2_out[0], stage2_out[7:1]}, out);
endmodule