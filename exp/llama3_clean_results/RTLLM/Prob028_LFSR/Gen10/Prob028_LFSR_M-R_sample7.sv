// Refactored LFSR implementation with improved structure and flexibility
module LFSR(
    input  clk,        // Clock signal
    input  rst,        // Active high reset signal
    output reg [3:0] out // 4-bit output representing the current state of the LFSR
);

always @ (posedge clk) begin
    if (rst) begin
        // Initialize with a non-zero value for the LFSR to generate a sequence
        out <= 4'b1001;
    end else begin
        // Calculate feedback based on the XOR of specific bits in the register
        reg [3:0] feedback;
        feedback = {out[3] ^ out[2] ^ out[1], out[3:1]};
        out <= feedback;
    end
end

endmodule

// Refactored testbench to verify the LFSR module
module tb_LFSR;
reg clk; // Clock signal
reg rst; // Active high reset signal
wire [3:0] out; // 4-bit output representing the current state of the LFSR

LFSR uut (.clk(clk),.rst(rst),.out(out));

initial begin
    clk = 0;
    rst = 1;
    #10;
    rst = 0;
    forever #5 clk = ~clk;
end

initial begin
    $monitor("out = %b", out);
    #100;
    $finish;
end

endmodule