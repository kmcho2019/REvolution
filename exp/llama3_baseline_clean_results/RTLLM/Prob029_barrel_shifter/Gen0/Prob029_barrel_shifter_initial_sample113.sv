// mux2X1 submodule definition
module mux2X1(out, a, b, sel);
    output [7:0] out;
    input [7:0] a, b;
    input sel;

    assign out = sel ? b : a;
endmodule

// barrel_shifter module definition
module barrel_shifter(out, in, ctrl);
    output [7:0] out;
    input [7:0] in;
    input [2:0] ctrl;

    // Intermediate signals for each stage
    wire [7:0] stage1_out, stage2_out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 stage1mux(out, in, {in[3:0], 4'b0000}, ctrl[2]);
    assign stage1_out = stage1mux.out;

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 stage2mux(stage2_out, stage1_out, {stage1_out[1:0], 6'b000000}, ctrl[1]);

    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 stage3mux(out, stage2_out, {stage2_out[0], 7'b0000000}, ctrl[0]);
endmodule