// mux2X1 submodule for selecting between two inputs based on sel
module mux2X1(a, b, sel, out);
    input [7:0] a, b;
    input sel;
    output [7:0] out;

    assign out = (sel) ? b : a;
endmodule

// Barrel shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // Intermediate wires for staging shifts
    wire [7:0] stage1_out, stage2_out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 #(.WIDTH(8)) stage1_mux(
        .a(in), 
        .b({in[3:0], 4'h0}), // Shift in by 4 positions
        .sel(ctrl[2]), 
        .out(stage1_out)
    );

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 #(.WIDTH(8)) stage2_mux(
        .a(stage1_out), 
        .b({stage1_out[5:0], 2'h0}), // Shift stage1_out by 2 positions
        .sel(ctrl[1]), 
        .out(stage2_out)
    );

    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 #(.WIDTH(8)) stage3_mux(
        .a(stage2_out), 
        .b({stage2_out[6:0], 1'h0}), // Shift stage2_out by 1 position
        .sel(ctrl[0]), 
        .out(out)
    );
endmodule