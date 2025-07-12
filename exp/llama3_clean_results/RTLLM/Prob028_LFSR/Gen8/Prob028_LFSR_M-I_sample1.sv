// Improved LFSR module with optimized reset and clock handling
module LFSR(
    input clk, // Clock signal
    input rst, // Active high reset signal
    output reg [3:0] out // 4-bit output representing the current state of the LFSR
);

// Sequential logic block to update the LFSR state
always @(posedge clk or posedge rst) begin
    if (rst) begin // Reset condition
        out <= 4'b0000; // Initialize output to zero
    end else begin // Normal operation
        // Calculate feedback as the inversion of the XOR of the most significant and second most significant bits
        out <= {out[2:0], ~(out[3] ^ out[2])}; // Shift left and insert feedback at the LSB
    end
end

endmodule

// Testbench for the LFSR module
module LFSR_tb;

reg clk; // Clock signal
reg rst; // Active high reset signal
wire [3:0] out; // 4-bit output representing the current state of the LFSR

// Instantiate the LFSR module
LFSR uut (
    .clk(clk),
    .rst(rst),
    .out(out)
);

// Initialize clock and reset signals
initial begin
    clk = 0;
    rst = 1;
end

// Clock generation
always #5 clk = ~clk; // 10ns clock period

// Reset release after 10ns
initial #10 rst = 0;

// Simulation end condition
initial #200 $finish;

// Print output at every clock cycle
always @(posedge clk) begin
    $display("out = %b", out);
end

endmodule