// Define the 2-to-1 multiplexer submodule
module mux2X1(in0, in1, sel, out);
    input [7:0] in0, in1;
    input sel;
    output [7:0] out;

    assign out = (sel)? in1 : in0;
endmodule

// Define the barrel shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    wire [7:0] stage1_in0, stage1_in1, stage1_out;
    assign stage1_in0 = in;
    assign stage1_in1 = {in[3:0], 4'b0000}; // Shift in by 4 positions
    mux2X1 mux_stage1(stage1_in0, stage1_in1, ctrl[2], stage1_out);

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    wire [7:0] stage2_in0, stage2_in1, stage2_out;
    assign stage2_in0 = stage1_out;
    assign stage2_in1 = {stage1_out[5:0], 2'b00}; // Shift stage1_out by 2 positions
    mux2X1 mux_stage2(stage2_in0, stage2_in1, ctrl[1], stage2_out);

    // Stage 3: Shift by 1 position if ctrl[0] is high
    wire [7:0] stage3_in0, stage3_in1, stage3_out;
    assign stage3_in0 = stage2_out;
    assign stage3_in1 = {stage2_out[6:0], 1'b0}; // Shift stage2_out by 1 position
    mux2X1 mux_stage3(stage3_in0, stage3_in1, ctrl[0], stage3_out);

    // Final output
    assign out = stage3_out;
endmodule