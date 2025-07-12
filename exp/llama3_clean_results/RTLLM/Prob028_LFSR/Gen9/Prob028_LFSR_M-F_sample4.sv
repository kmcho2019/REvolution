// Corrected LFSR module
module LFSR(
    input clk, // Clock signal
    input rst, // Active high reset signal
    output reg [3:0] out // 4-bit output representing the current state of the LFSR
);

always @ (posedge clk) begin
    if (rst) begin
        out <= 4'b0;
    end else begin
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule

// Corrected testbench
module tb_LFSR;
reg clk; // Declare clk as a single-bit reg
reg rst; // Declare rst as a single-bit reg
wire [3:0] out; // Correctly declare out as a 4-bit wire

LFSR uut (.clk(clk), .rst(rst), .out(out)); // Instantiate LFSR with correct port connections

initial begin
    clk = 0; // Initialize clk to 0
    rst = 1; // Initialize rst to 1 (active high)
    #10; // Wait for 10 time units
    rst = 0; // De-assert rst
    forever #5 clk = ~clk; // Toggle clk every 5 time units
end

initial begin
    #100; // Wait for 100 time units
    $finish; // Finish the simulation
end

endmodule