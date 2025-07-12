module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

// Define the mux2X1 submodule
module mux2X1(
    input [7:0] in0,
    input [7:0] in1,
    input sel,
    output [7:0] out
);
    assign out = (sel == 1'b1) ? in1 : in0;
endmodule

// First stage: shift by 4 positions if ctrl[2] is high
wire [7:0] stage1_out;
mux2X1 stage1_m0 (.in0(in), .in1({in[3:0], 4'b0000}), .sel(ctrl[2]), .out(stage1_out[0]));
mux2X1 stage1_m1 (.in0(in), .in1({in[3:0], 4'b0000}), .sel(ctrl[2]), .out(stage1_out[1]));
mux2X1 stage1_m2 (.in0(in), .in1({in[3:0], 4'b0000}), .sel(ctrl[2]), .out(stage1_out[2]));
mux2X1 stage1_m3 (.in0(in), .in1({in[3:0], 4'b0000}), .sel(ctrl[2]), .out(stage1_out[3]));
mux2X1 stage1_m4 (.in0(in), .in1({in[3:0], 4'b0000}), .sel(ctrl[2]), .out(stage1_out[4]));
mux2X1 stage1_m5 (.in0(in), .in1({in[3:0], 4'b0000}), .sel(ctrl[2]), .out(stage1_out[5]));
mux2X1 stage1_m6 (.in0(in), .in1({in[3:0], 4'b0000}), .sel(ctrl[2]), .out(stage1_out[6]));
mux2X1 stage1_m7 (.in0(in), .in1({in[3:0], 4'b0000}), .sel(ctrl[2]), .out(stage1_out[7]));

// Second stage: shift by 2 positions if ctrl[1] is high
wire [7:0] stage2_out;
mux2X1 stage2_m0 (.in0(stage1_out), .in1({stage1_out[6:0], 2'b00}), .sel(ctrl[1]), .out(stage2_out[0]));
mux2X1 stage2_m1 (.in0(stage1_out), .in1({stage1_out[6:0], 2'b00}), .sel(ctrl[1]), .out(stage2_out[1]));
mux2X1 stage2_m2 (.in0(stage1_out), .in1({stage1_out[6:0], 2'b00}), .sel(ctrl[1]), .out(stage2_out[2]));
mux2X1 stage2_m3 (.in0(stage1_out), .in1({stage1_out[6:0], 2'b00}), .sel(ctrl[1]), .out(stage2_out[3]));
mux2X1 stage2_m4 (.in0(stage1_out), .in1({stage1_out[6:0], 2'b00}), .sel(ctrl[1]), .out(stage2_out[4]));
mux2X1 stage2_m5 (.in0(stage1_out), .in1({stage1_out[6:0], 2'b00}), .sel(ctrl[1]), .out(stage2_out[5]));
mux2X1 stage2_m6 (.in0(stage1_out), .in1({stage1_out[6:0], 2'b00}), .sel(ctrl[1]), .out(stage2_out[6]));
mux2X1 stage2_m7 (.in0(stage1_out), .in1({stage1_out[6:0], 2'b00}), .sel(ctrl[1]), .out(stage2_out[7]));

// Third stage: shift by 1 position if ctrl[0] is high
assign out = (ctrl[0] == 1'b1) ? {stage2_out[6:0], stage2_out[7]} : stage2_out;

endmodule