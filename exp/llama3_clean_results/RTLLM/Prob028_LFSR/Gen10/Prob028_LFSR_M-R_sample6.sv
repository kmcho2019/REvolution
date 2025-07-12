// Refactored LFSR module
module LFSR(
    input clk, // Clock signal
    input rst, // Active high reset signal
    output reg [3:0] out // 4-bit output representing the current state of the LFSR
);

wire feedback; // Declare a wire for the feedback signal

// Continuous assignment for calculating the feedback signal
assign feedback = ~(out[3] ^ out[2]);

// Always block for handling clock edge and reset
always @ (posedge clk) begin
    if (rst) begin
        out <= 4'b0; // Reset the LFSR to 0 on active high reset
    end else begin
        out <= {out[2:0], feedback}; // Shift and insert feedback on clock edge
    end
end

endmodule

// Refactored testbench remains largely the same
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