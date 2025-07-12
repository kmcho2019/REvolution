module LFSR #(
    parameter WIDTH = 4,
    parameter SEED = 4'b0001  // Non-zero seed to avoid lock-up state
) (
    input  wire clk,
    input  wire rst,
    output reg  [WIDTH-1:0] out
);

// Feedback taps: bits 3 and 2 for 4-bit LFSR
wire feedback = out[WIDTH-1] ^ out[WIDTH-2];

always @(posedge clk) begin
    if (rst) begin
        out <= SEED;  // Initialize with seed value
    end else begin
        out <= {out[WIDTH-2:0], feedback};  // Shift left and insert feedback
    end
end

endmodule

module LFSR_tb;

// Testbench signals
reg clk;
reg rst;
wire [3:0] out;

// Instantiate DUT
LFSR dut (
    .clk(clk),
    .rst(rst),
    .out(out)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Stimulus
initial begin
    rst = 1;  // Assert reset
    #20;
    rst = 0;  // Release reset
    
    // Monitor LFSR output
    $monitor("At time %0t: out = %b", $time, out);
    
    // Run for 32 cycles (2 full periods of 4-bit LFSR)
    #160;
    $finish;
end

endmodule