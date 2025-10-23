// Define a 2-to-1 multiplexer submodule
module mux2X1(in0, in1, sel, out);
    input [7:0] in0, in1;
    input sel;
    output [7:0] out;

    reg [7:0] out;

    always @(*)
    begin
        if (sel)
            out = in1;
        else
            out = in0;
    end
endmodule

// Top-level barrel shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    reg [7:0] out;
    reg [7:0] stage1_out, stage2_out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 in, {in[3:0], 4'h0}, ctrl[2], stage1_out;

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 stage1_out, {stage1_out[5:0], 2'h0}, ctrl[1], stage2_out;

    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 stage2_out, {stage2_out[6:0], 1'h0}, ctrl[0], out;
endmodule