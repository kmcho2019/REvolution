module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // Define the mux2x1 submodule
    module mux2x1(a, b, sel, out);
        input [7:0] a, b;
        input sel;
        output [7:0] out;

        assign out = sel ? b : a;
    endmodule

    // First stage: shift by 4 positions if ctrl[2] is high
    wire [7:0] stage1_out;
    mux2x1 #(.WIDTH(8)) stage1_mux(in, {in[3:0], 4'd0}, ctrl[2], stage1_out);

    // Second stage: shift by 2 positions if ctrl[1] is high
    wire [7:0] stage2_out;
    mux2x1 #(.WIDTH(8)) stage2_mux(stage1_out, {stage1_out[5:0], 2'd0}, ctrl[1], stage2_out);

    // Third stage: shift by 1 position if ctrl[0] is high
    mux2x1 #(.WIDTH(8)) stage3_mux(stage2_out, {stage2_out[6:0], stage2_out[7]}, ctrl[0], out);
endmodule