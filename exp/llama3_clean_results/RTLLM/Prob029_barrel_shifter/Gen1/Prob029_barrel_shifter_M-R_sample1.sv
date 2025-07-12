module mux2X1(in0, in1, sel, out);
    input [7:0] in0, in1;
    input sel;
    output [7:0] out;

    assign out = (sel) ? in1 : in0;
endmodule

module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    wire [7:0] stage1_out, stage2_out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    wire [7:0] in_shift4;
    assign in_shift4 = {in[3:0], 4'b0000};
    mux2X1 u_mux1(.in0(in), .in1(in_shift4), .sel(ctrl[2]), .out(stage1_out));

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    wire [7:0] stage1_out_shift2;
    assign stage1_out_shift2 = {stage1_out[5:0], 2'b00};
    mux2X1 u_mux2(.in0(stage1_out), .in1(stage1_out_shift2), .sel(ctrl[1]), .out(stage2_out));

    // Stage 3: Shift by 1 position if ctrl[0] is high
    wire [7:0] stage2_out_shift1;
    assign stage2_out_shift1 = {stage2_out[6:0], 1'b0};
    mux2X1 u_mux3(.in0(stage2_out), .in1(stage2_out_shift1), .sel(ctrl[0]), .out(out));
endmodule