module mux2X1(input [7:0] in0, in1, output [7:0] out, input sel);
    assign out = (sel) ? in1 : in0;
endmodule

module barrel_shifter(input [7:0] in, input [2:0] ctrl, output [7:0] out);
    wire [7:0] stage1_out, stage2_out;

    // Shift by 4 positions based on ctrl[2]
    mux2X1 mux_stage1(.in0(in), .in1({in[3:0], 4'b0000}), .out(stage1_out), .sel(ctrl[2]));

    // Shift by 2 positions based on ctrl[1]
    mux2X1 mux_stage2(.in0(stage1_out), .in1({stage1_out[5:0], 2'b00}), .out(stage2_out), .sel(ctrl[1]));

    // Shift by 1 position based on ctrl[0]
    mux2X1 mux_stage3(.in0(stage2_out), .in1({stage2_out[6:0], 1'b0}), .out(out), .sel(ctrl[0]));
endmodule