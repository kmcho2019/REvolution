// Define the mux2X1 submodule
module mux2X1(a, b, sel, out);
    input [7:0] a, b;
    input sel;
    output [7:0] out;

    assign out = sel ? b : a;
endmodule

// Define the barrel_shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    wire [7:0] stage1_out;
    mux2X1 m1(.a(in), .b({in[3:0], 4'b0000}), .sel(ctrl[2]), .out(stage1_out));

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    wire [7:0] stage2_out;
    mux2X1 m2(.a(stage1_out), .b({stage1_out[5:0], 2'b00}), .sel(ctrl[1]), .out(stage2_out));

    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 m3(.a(stage2_out), .b({stage2_out[6:0], stage2_out[7]}), .sel(ctrl[0]), .out(out));
endmodule