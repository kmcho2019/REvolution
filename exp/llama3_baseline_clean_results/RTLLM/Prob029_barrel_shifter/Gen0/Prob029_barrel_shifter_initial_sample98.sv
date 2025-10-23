// Define a 2-to-1 multiplexer submodule
module mux2X1(sel, a, b, out);
    input sel;
    input [7:0] a, b;
    output [7:0] out;

    assign out = (sel == 1'b1) ? b : a;
endmodule

// Define the barrel shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    wire [7:0] stage1_in [1:0];
    assign stage1_in[0] = in; // Original input
    assign stage1_in[1] = {in[3:0], in[7:4]}; // Input shifted by 4 positions
    wire [7:0] stage1_out;
    mux2X1 #(.WIDTH(8)) mux_stage1(ctrl[2], stage1_in[0], stage1_in[1], stage1_out);

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    wire [7:0] stage2_in [1:0];
    assign stage2_in[0] = stage1_out; // Intermediate result from stage 1
    assign stage2_in[1] = {stage1_out[5:0], stage1_out[7:6]}; // Intermediate result shifted by 2 positions
    wire [7:0] stage2_out;
    mux2X1 #(.WIDTH(8)) mux_stage2(ctrl[1], stage2_in[0], stage2_in[1], stage2_out);

    // Stage 3: Shift by 1 position if ctrl[0] is high
    wire [7:0] stage3_in [1:0];
    assign stage3_in[0] = stage2_out; // Intermediate result from stage 2
    assign stage3_in[1] = {stage2_out[6:0], stage2_out[7]}; // Intermediate result shifted by 1 position
    assign out = stage3_in[0]; // Output of the barrel shifter
    mux2X1 #(.WIDTH(8)) mux_stage3(ctrl[0], stage3_in[0], stage3_in[1], out);
endmodule