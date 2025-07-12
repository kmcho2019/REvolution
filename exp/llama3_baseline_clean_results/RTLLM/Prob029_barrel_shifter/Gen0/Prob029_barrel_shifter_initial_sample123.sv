// mux2X1 submodule
module mux2X1(out, a, b, sel);
    output out;
    input a, b, sel;

    assign out = (sel) ? b : a;
endmodule

// barrel_shifter module
module barrel_shifter(out, in, ctrl);
    output [7:0] out;
    input [7:0] in;
    input [2:0] ctrl;

    // Stage 1: Shift by 4 positions
    wire [7:0] stage1_shifted, stage1_unshifted;
    assign stage1_shifted = (ctrl[2]) ? {in[3:0], 4'b0000} : in;
    assign stage1_unshifted = in;

    // Stage 1 multiplexers
    wire [7:0] stage1_out;
    mux2X1 stage1_mux[7:0] (.out(stage1_out[7:0]), .a(stage1_unshifted[7:0]), .b(stage1_shifted[7:0]), .sel(ctrl[2]));

    // Stage 2: Shift by 2 positions
    wire [7:0] stage2_shifted, stage2_unshifted;
    assign stage2_shifted = (ctrl[1]) ? {stage1_out[5:0], 2'b00} : stage1_out;
    assign stage2_unshifted = stage1_out;

    // Stage 2 multiplexers
    wire [7:0] stage2_out;
    mux2X1 stage2_mux[7:0] (.out(stage2_out[7:0]), .a(stage2_unshifted[7:0]), .b(stage2_shifted[7:0]), .sel(ctrl[1]));

    // Stage 3: Shift by 1 position
    wire [7:0] stage3_shifted, stage3_unshifted;
    assign stage3_shifted = (ctrl[0]) ? {stage2_out[6:0], 1'b0} : stage2_out;
    assign stage3_unshifted = stage2_out;

    // Stage 3 multiplexers
    mux2X1 stage3_mux[7:0] (.out(out[7:0]), .a(stage3_unshifted[7:0]), .b(stage3_shifted[7:0]), .sel(ctrl[0]));
endmodule