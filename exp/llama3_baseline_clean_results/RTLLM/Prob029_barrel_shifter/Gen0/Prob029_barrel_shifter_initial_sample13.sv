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
    assign out = sel? in1 : in0;
endmodule

// Stage 1: Shift by 4 positions if ctrl[2] is high
wire [7:0] stage1_in0;
assign stage1_in0 = in;
wire [7:0] stage1_in1;
assign stage1_in1 = {in[3:0], 4'b0000};
mux2X1 stage1_mux(
   .in0(stage1_in0),
   .in1(stage1_in1),
   .sel(ctrl[2]),
   .out(out_stage1)
);

// Stage 2: Shift by 2 positions if ctrl[1] is high
wire [7:0] stage2_in0;
assign stage2_in0 = out_stage1;
wire [7:0] stage2_in1;
assign stage2_in1 = {out_stage1[5:0], 2'b00};
mux2X1 stage2_mux(
   .in0(stage2_in0),
   .in1(stage2_in1),
   .sel(ctrl[1]),
   .out(out_stage2)
);

// Stage 3: Shift by 1 position if ctrl[0] is high
wire [7:0] stage3_in0;
assign stage3_in0 = out_stage2;
wire [7:0] stage3_in1;
assign stage3_in1 = {out_stage2[6:0], 1'b0};
mux2X1 stage3_mux(
   .in0(stage3_in0),
   .in1(stage3_in1),
   .sel(ctrl[0]),
   .out(out)
);

wire [7:0] out_stage1;
wire [7:0] out_stage2;

endmodule