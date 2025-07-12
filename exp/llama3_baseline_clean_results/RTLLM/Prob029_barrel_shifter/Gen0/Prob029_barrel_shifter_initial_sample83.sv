// Define a 2-to-1 multiplexer submodule
module mux2X1(in0, in1, sel, out);
    input [7:0] in0, in1;
    input sel;
    output [7:0] out;

    assign out = sel? in1 : in0;
endmodule

// Define the barrel shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // First stage: Shift by 4 positions if ctrl[2] is high
    wire [7:0] stage1_out;
    mux2X1 stage1 mux(.in0(in),.in1({in[3:0], 4'h0}),.sel(ctrl[2]),.out(stage1_out));

    // Second stage: Shift by 2 positions if ctrl[1] is high
    wire [7:0] stage2_out;
    mux2X1 stage2 mux(.in0(stage1_out),.in1({stage1_out[5:0], 2'h0}),.sel(ctrl[1]),.out(stage2_out));

    // Third stage: Shift by 1 position if ctrl[0] is high
    mux2X1 stage3 mux(.in0(stage2_out),.in1({stage2_out[6:0], 1'h0}),.sel(ctrl[0]),.out(out));
endmodule