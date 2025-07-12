// Define the mux2X1 submodule
module mux2X1(sel, in0, in1, out);
    input sel;
    input [7:0] in0, in1;
    output [7:0] out;

    assign out = (sel) ? in1 : in0;
endmodule

// Define the barrel shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    wire [7:0] stage1_out;
    mux2X1 mux1(ctrl[2], in, {in[3:0], in[7:4]}, stage1_out);

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    wire [7:0] stage2_out;
    mux2X1 mux2(ctrl[1], stage1_out, {stage1_out[5:0], stage1_out[7:6]}, stage2_out);

    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 mux3(ctrl[0], stage2_out, {stage2_out[6:0], stage2_out[7]}, out);
endmodule

// Testbench
module tb_barrel_shifter;
    reg [7:0] in;
    reg [2:0] ctrl;
    wire [7:0] out;

    barrel_shifter uut(in, ctrl, out);

    initial begin
        in = 8'b11010101;
        ctrl = 3'b101;
        #10 $display("out = %b", out);
        
        in = 8'b11010101;
        ctrl = 3'b110;
        #10 $display("out = %b", out);
        
        in = 8'b11010101;
        ctrl = 3'b111;
        #10 $display("out = %b", out);
    end
endmodule