module LFSR #(
    parameter FEEDBACK_POLY = 4'b1100  // Default: taps at bits 3 and 2 (x^4 + x^3 + 1)
)(
    input wire clk,            // Clock input
    input wire rst,            // Active-high synchronous reset
    input wire load,           // Parallel load enable
    input wire [3:0] seed,     // Initial seed value
    output reg [3:0] out,      // 4-bit LFSR state output
    output wire max_cycle      // Pulses when sequence completes
);

// Feedback calculation based on selected polynomial taps
wire feedback = ^(out & FEEDBACK_POLY);

// Track if we've returned to the loaded seed
reg [3:0] loaded_seed;
reg cycle_complete;

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0001;        // Default reset state
        loaded_seed <= 4'b0001;
        cycle_complete <= 0;
    end
    else if (load) begin
        out <= seed;           // Load new seed
        loaded_seed <= seed;
        cycle_complete <= 0;
    end
    else begin
        // Shift left and insert feedback at LSB
        out <= {out[2:0], feedback};
        
        // Check for cycle completion (excluding all-0 state)
        cycle_complete <= (out == loaded_seed) && (|out);
    end
end

assign max_cycle = cycle_complete;

endmodule

module LFSR_tb;

reg clk;
reg rst;
reg load;
reg [3:0] seed;
wire [3:0] out;
wire max_cycle;

// Instantiate with default feedback polynomial
LFSR dut (
    .clk(clk),
    .rst(rst),
    .load(load),
    .seed(seed),
    .out(out),
    .max_cycle(max_cycle)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test sequence
initial begin
    // Initialize
    rst = 1;
    load = 0;
    seed = 4'b0000;
    #10;
    
    // Release reset
    rst = 0;
    #10;
    
    // Test normal operation
    $display("Testing default operation...");
    #160;  // Wait for one full cycle (15 states)
    
    // Test parallel load
    $display("Testing parallel load...");
    load = 1;
    seed = 4'b1010;
    #10;
    load = 0;
    #160;
    
    // End simulation
    $display("Simulation complete");
    $finish;
end

// Monitor the output
initial begin
    $monitor("Time = %0t, State = %b, Max Cycle = %b", $time, out, max_cycle);
end

endmodule