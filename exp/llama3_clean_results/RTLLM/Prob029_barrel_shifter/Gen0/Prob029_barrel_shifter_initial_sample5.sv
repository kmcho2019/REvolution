// Define a 2-to-1 multiplexer module
module mux2X1(in, sel, out);
    input [7:0] in;
    input sel;
    output [7:0] out;

    assign out = (sel == 1'b1)? (in >> 1) : in;
endmodule

// Define the barrel shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    wire [7:0] stage1_out;
    wire [7:0] stage2_out;
    wire [7:0] stage3_out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 stage1_mux1(in, ctrl[2], stage1_out);
    assign stage1_out = (ctrl[2] == 1'b1)? {in[3:0], 4'h0} : in;

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 stage2_mux1(stage1_out, ctrl[1], stage2_out);
    assign stage2_out = (ctrl[1] == 1'b1)? {stage1_out[6:0], 1'b0} : stage1_out;

    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 stage3_mux1(stage2_out, ctrl[0], stage3_out);
    assign stage3_out = (ctrl[0] == 1'b1)? {stage2_out[6:0], 1'b0} : stage2_out;

    assign out = stage3_out;

endmodule