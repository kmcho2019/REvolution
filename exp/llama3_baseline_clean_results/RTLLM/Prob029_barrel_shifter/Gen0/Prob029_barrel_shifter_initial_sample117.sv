// Define the mux2X1 submodule
module mux2X1(a, b, sel, out);
    input [7:0] a, b;
    input sel;
    output [7:0] out;
    
    assign out = (sel) ? b : a;
endmodule

// Define the barrel_shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;
    
    // Stage 1: Shift by 4 positions
    wire [7:0] stage1_in;
    assign stage1_in = (ctrl[2]) ? {in[3:0], 4'h0} : in;
    
    // Stage 2: Shift by 2 positions
    wire [7:0] stage2_in;
    mux2X1 stage1_out(stage1_in, {stage1_in[5:0], 2'h0}, ctrl[1], stage2_in);
    
    // Stage 3: Shift by 1 position
    mux2X1 stage2_out(stage2_in, {stage2_in[6:0], 1'h0}, ctrl[0], out);
endmodule

// Testbench for the barrel_shifter module
module testbench();
    reg [7:0] in;
    reg [2:0] ctrl;
    wire [7:0] out;
    
    barrel_shifter dut(in, ctrl, out);
    
    initial begin
        in = 8'h11;
        ctrl = 3'b000;
        #10;
        $display("Input: %h, Ctrl: %b, Output: %h", in, ctrl, out);
        
        in = 8'h11;
        ctrl = 3'b001;
        #10;
        $display("Input: %h, Ctrl: %b, Output: %h", in, ctrl, out);
        
        in = 8'h11;
        ctrl = 3'b010;
        #10;
        $display("Input: %h, Ctrl: %b, Output: %h", in, ctrl, out);
        
        in = 8'h11;
        ctrl = 3'b100;
        #10;
        $display("Input: %h, Ctrl: %b, Output: %h", in, ctrl, out);
    end
endmodule