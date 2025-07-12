module mux2X1(a, b, sel, out);
    input [7:0] a, b;
    input sel;
    output [7:0] out;
    assign out = sel ? b : a;
endmodule

module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    wire [7:0] stage1_out, stage2_out;

    // Shift by 4 positions if ctrl[2] is high
    mux2X1 mux0_4 (.a(in), .b({in[3:0], 4'b0000}), .sel(ctrl[2]), .out(stage1_out[0]));
    mux2X1 mux1_4 (.a(in), .b({in[3:0], 4'b0000}), .sel(ctrl[2]), .out(stage1_out[1]));
    mux2X1 mux2_4 (.a(in), .b({in[3:0], 4'b0000}), .sel(ctrl[2]), .out(stage1_out[2]));
    mux2X1 mux3_4 (.a(in), .b({in[3:0], 4'b0000}), .sel(ctrl[2]), .out(stage1_out[3]));
    mux2X1 mux4_4 (.a(in), .b({in[3:0], 4'b0000}), .sel(ctrl[2]), .out(stage1_out[4]));
    mux2X1 mux5_4 (.a(in), .b({in[3:0], 4'b0000}), .sel(ctrl[2]), .out(stage1_out[5]));
    mux2X1 mux6_4 (.a(in), .b({in[3:0], 4'b0000}), .sel(ctrl[2]), .out(stage1_out[6]));
    mux2X1 mux7_4 (.a(in), .b({in[3:0], 4'b0000}), .sel(ctrl[2]), .out(stage1_out[7]));

    // Shift by 2 positions if ctrl[1] is high
    mux2X1 mux0_2 (.a(stage1_out), .b({stage1_out[6:0], stage1_out[7]}), .sel(ctrl[1]), .out(stage2_out[0]));
    mux2X1 mux1_2 (.a(stage1_out), .b({stage1_out[6:0], stage1_out[7]}), .sel(ctrl[1]), .out(stage2_out[1]));
    mux2X1 mux2_2 (.a(stage1_out), .b({stage1_out[6:0], stage1_out[7]}), .sel(ctrl[1]), .out(stage2_out[2]));
    mux2X1 mux3_2 (.a(stage1_out), .b({stage1_out[6:0], stage1_out[7]}), .sel(ctrl[1]), .out(stage2_out[3]));
    mux2X1 mux4_2 (.a(stage1_out), .b({stage1_out[6:0], stage1_out[7]}), .sel(ctrl[1]), .out(stage2_out[4]));
    mux2X1 mux5_2 (.a(stage1_out), .b({stage1_out[6:0], stage1_out[7]}), .sel(ctrl[1]), .out(stage2_out[5]));
    mux2X1 mux6_2 (.a(stage1_out), .b({stage1_out[6:0], stage1_out[7]}), .sel(ctrl[1]), .out(stage2_out[6]));
    mux2X1 mux7_2 (.a(stage1_out), .b({stage1_out[6:0], stage1_out[7]}), .sel(ctrl[1]), .out(stage2_out[7]));

    // Shift by 1 position if ctrl[0] is high
    mux2X1 mux0_1 (.a(stage2_out), .b({stage2_out[7:1], stage2_out[0]}), .sel(ctrl[0]), .out(out[0]));
    mux2X1 mux1_1 (.a(stage2_out), .b({stage2_out[7:1], stage2_out[0]}), .sel(ctrl[0]), .out(out[1]));
    mux2X1 mux2_1 (.a(stage2_out), .b({stage2_out[7:1], stage2_out[0]}), .sel(ctrl[0]), .out(out[2]));
    mux2X1 mux3_1 (.a(stage2_out), .b({stage2_out[7:1], stage2_out[0]}), .sel(ctrl[0]), .out(out[3]));
    mux2X1 mux4_1 (.a(stage2_out), .b({stage2_out[7:1], stage2_out[0]}), .sel(ctrl[0]), .out(out[4]));
    mux2X1 mux5_1 (.a(stage2_out), .b({stage2_out[7:1], stage2_out[0]}), .sel(ctrl[0]), .out(out[5]));
    mux2X1 mux6_1 (.a(stage2_out), .b({stage2_out[7:1], stage2_out[0]}), .sel(ctrl[0]), .out(out[6]));
    mux2X1 mux7_1 (.a(stage2_out), .b({stage2_out[7:1], stage2_out[0]}), .sel(ctrl[0]), .out(out[7]));
endmodule