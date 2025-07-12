// Define the 2-to-1 multiplexer submodule
module mux2X1(a, b, sel, out);
    input [7:0] a, b;
    input sel;
    output [7:0] out;
    assign out = sel ? b : a;
endmodule

// Define the barrel shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;
    
    // First stage: shift by 4 positions if ctrl[2] is high
    wire [7:0] stage1_shifted;
    assign stage1_shifted = {in[3:0], 4'b0000};
    wire [7:0] stage1_out;
    mux2X1 #(.WIDTH(8)) stage1_mux(in, stage1_shifted, ctrl[2], stage1_out);
    
    // Second stage: shift by 2 positions if ctrl[1] is high
    wire [7:0] stage2_shifted;
    assign stage2_shifted = {stage1_out[5:0], 2'b00};
    wire [7:0] stage2_out;
    mux2X1 #(.WIDTH(8)) stage2_mux(stage1_out, stage2_shifted, ctrl[1], stage2_out);
    
    // Third stage: shift by 1 position if ctrl[0] is high
    wire [7:0] stage3_shifted;
    assign stage3_shifted = {stage2_out[6:0], 1'b0};
    assign out = ctrl[0] ? stage3_shifted : stage2_out;
endmodule