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

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    wire [7:0] shifted_by_4;
    assign shifted_by_4 = {in[3:0], 4'b0000};

    wire [7:0] stage1_out;
    mux2X1 u_mux1_1 (in, shifted_by_4, ctrl[2], stage1_out);

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    wire [7:0] shifted_by_2;
    assign shifted_by_2 = {stage1_out[5:0], 2'b00};

    wire [7:0] stage2_out;
    mux2X1 u_mux2_1 (stage1_out, shifted_by_2, ctrl[1], stage2_out);

    // Stage 3: Shift by 1 position if ctrl[0] is high
    wire [7:0] shifted_by_1;
    assign shifted_by_1 = {stage2_out[6:0], 1'b0};

    mux2X1 u_mux3_1 (stage2_out, shifted_by_1, ctrl[0], out);
endmodule