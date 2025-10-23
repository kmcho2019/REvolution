module barrel_shifter(
    input  [7:0] in,
    input  [2:0] ctrl,
    output [7:0] out
);

// Submodule for 2-to-1 multiplexer
module mux2X1(
    input [7:0] in0, in1,
    input       sel,
    output [7:0] out
);
    assign out = sel ? in1 : in0;
endmodule

// Stage 1: Shift by 4 positions if ctrl[2] is high
wire [7:0] stage1_shifted;
assign stage1_shifted = {in[3:0], 4'b0000};
wire [7:0] stage1_out;
mux2X1 stage1_mux(in, stage1_shifted, ctrl[2], stage1_out);

// Stage 2: Shift by 2 positions if ctrl[1] is high
wire [7:0] stage2_shifted;
assign stage2_shifted = {stage1_out[5:0], 2'b00};
wire [7:0] stage2_out;
mux2X1 stage2_mux(stage1_out, stage2_shifted, ctrl[1], stage2_out);

// Stage 3: Shift by 1 position if ctrl[0] is high
wire [7:0] stage3_shifted;
assign stage3_shifted = {stage2_out[6:0], 1'b0};
assign out = ctrl[0] ? stage3_shifted : stage2_out;

endmodule