// Define a 2-to-1 multiplexer submodule
module mux2X1(a, b, sel, out);
    input [7:0] a, b;
    input sel;
    output [7:0] out;

    assign out = (sel) ? b : a;
endmodule

// Define the barrel shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // Internal wires for each stage
    wire [7:0] stage1_out, stage2_out, stage3_out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 u1 (.a(in), .b({in[3:0], 4'b0000}), .sel(ctrl[2]), .out(stage1_out));

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 u2 (.a(stage1_out), .b({stage1_out[5:0], 2'b00}), .sel(ctrl[1]), .out(stage2_out));

    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 u3 (.a(stage2_out), .b({stage2_out[6:0], 1'b0}), .sel(ctrl[0]), .out(stage3_out));

    // Assign the final output
    assign out = stage3_out;
endmodule