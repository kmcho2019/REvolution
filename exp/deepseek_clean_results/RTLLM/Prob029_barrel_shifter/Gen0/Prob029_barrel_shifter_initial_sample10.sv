module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

    wire [7:0] stage1_out, stage2_out;

    // Stage 1: Shift by 4 bits (controlled by ctrl[2])
    mux2X1 mux_stage1_0 (.a(in[0]), .b(in[4]), .sel(ctrl[2]), .out(stage1_out[0]));
    mux2X1 mux_stage1_1 (.a(in[1]), .b(in[5]), .sel(ctrl[2]), .out(stage1_out[1]));
    mux2X1 mux_stage1_2 (.a(in[2]), .b(in[6]), .sel(ctrl[2]), .out(stage1_out[2]));
    mux2X1 mux_stage1_3 (.a(in[3]), .b(in[7]), .sel(ctrl[2]), .out(stage1_out[3]));
    mux2X1 mux_stage1_4 (.a(in[4]), .b(in[0]), .sel(ctrl[2]), .out(stage1_out[4]));
    mux2X1 mux_stage1_5 (.a(in[5]), .b(in[1]), .sel(ctrl[2]), .out(stage1_out[5]));
    mux2X1 mux_stage1_6 (.a(in[6]), .b(in[2]), .sel(ctrl[2]), .out(stage1_out[6]));
    mux2X1 mux_stage1_7 (.a(in[7]), .b(in[3]), .sel(ctrl[2]), .out(stage1_out[7]));

    // Stage 2: Shift by 2 bits (controlled by ctrl[1])
    mux2X1 mux_stage2_0 (.a(stage1_out[0]), .b(stage1_out[2]), .sel(ctrl[1]), .out(stage2_out[0]));
    mux2X1 mux_stage2_1 (.a(stage1_out[1]), .b(stage1_out[3]), .sel(ctrl[1]), .out(stage2_out[1]));
    mux2X1 mux_stage2_2 (.a(stage1_out[2]), .b(stage1_out[4]), .sel(ctrl[1]), .out(stage2_out[2]));
    mux2X1 mux_stage2_3 (.a(stage1_out[3]), .b(stage1_out[5]), .sel(ctrl[1]), .out(stage2_out[3]));
    mux2X1 mux_stage2_4 (.a(stage1_out[4]), .b(stage1_out[6]), .sel(ctrl[1]), .out(stage2_out[4]));
    mux2X1 mux_stage2_5 (.a(stage1_out[5]), .b(stage1_out[7]), .sel(ctrl[1]), .out(stage2_out[5]));
    mux2X1 mux_stage2_6 (.a(stage1_out[6]), .b(stage1_out[0]), .sel(ctrl[1]), .out(stage2_out[6]));
    mux2X1 mux_stage2_7 (.a(stage1_out[7]), .b(stage1_out[1]), .sel(ctrl[1]), .out(stage2_out[7]));

    // Stage 3: Shift by 1 bit (controlled by ctrl[0])
    mux2X1 mux_stage3_0 (.a(stage2_out[0]), .b(stage2_out[1]), .sel(ctrl[0]), .out(out[0]));
    mux2X1 mux_stage3_1 (.a(stage2_out[1]), .b(stage2_out[2]), .sel(ctrl[0]), .out(out[1]));
    mux2X1 mux_stage3_2 (.a(stage2_out[2]), .b(stage2_out[3]), .sel(ctrl[0]), .out(out[2]));
    mux2X1 mux_stage3_3 (.a(stage2_out[3]), .b(stage2_out[4]), .sel(ctrl[0]), .out(out[3]));
    mux2X1 mux_stage3_4 (.a(stage2_out[4]), .b(stage2_out[5]), .sel(ctrl[0]), .out(out[4]));
    mux2X1 mux_stage3_5 (.a(stage2_out[5]), .b(stage2_out[6]), .sel(ctrl[0]), .out(out[5]));
    mux2X1 mux_stage3_6 (.a(stage2_out[6]), .b(stage2_out[7]), .sel(ctrl[0]), .out(out[6]));
    mux2X1 mux_stage3_7 (.a(stage2_out[7]), .b(stage2_out[0]), .sel(ctrl[0]), .out(out[7]));

endmodule

module mux2X1 (
    input a,
    input b,
    input sel,
    output out
);
    assign out = sel ? b : a;
endmodule