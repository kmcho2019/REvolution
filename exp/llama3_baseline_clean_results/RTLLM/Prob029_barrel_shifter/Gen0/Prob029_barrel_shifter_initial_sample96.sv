// mux2X1 submodule: selects between two input values based on the sel signal
module mux2X1(sel, in0, in1, out);
    input sel;
    input [7:0] in0, in1;
    output [7:0] out;

    assign out = sel ? in1 : in0;
endmodule

// barrel_shifter module: shifts input based on the ctrl signal
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // wires to connect intermediate results
    wire [7:0] stage1_out, stage2_out;

    // stage 1: shift by 4 positions if ctrl[2] is high
    mux2X1 #(.WIDTH(8)) stage1_mux(ctrl[2], in, {in[3:0], 4'b0000}, stage1_out);

    // stage 2: shift by 2 positions if ctrl[1] is high
    mux2X1 #(.WIDTH(8)) stage2_mux(ctrl[1], stage1_out, {stage1_out[6:0], 2'b00}, stage2_out);

    // stage 3: shift by 1 position if ctrl[0] is high
    mux2X1 #(.WIDTH(8)) stage3_mux(ctrl[0], stage2_out, {stage2_out[7:1], stage2_out[0]}, out);
endmodule