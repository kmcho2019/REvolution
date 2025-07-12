module LFSR (
    input wire clk,            // Clock input
    input wire rst,            // Active-high synchronous reset
    input wire dir,            // Shift direction (0=left, 1=right)
    input wire fb_sel,         // Feedback polynomial select
    output reg [3:0] out,      // 4-bit LFSR state output
    output wire cycle_complete // Pulses when sequence completes
);

// Internal signals
wire feedback_left, feedback_right;
reg [3:0] initial_seed;
reg [14:0] cycle_counter;

// Feedback polynomial options:
// fb_sel=0: x^4 + x^3 + 1 (taps at bits 3 and 2)
// fb_sel=1: x^4 + x + 1 (taps at bits 3 and 0)
assign feedback_left = fb_sel ? (out[3] ^ out[0]) : (out[3] ^ out[2]);
assign feedback_right = fb_sel ? (out[0] ^ out[1]) : (out[0] ^ out[3]);

// Track initial seed for cycle completion detection
always @(posedge clk) begin
    if (rst) begin
        initial_seed <= 4'b0001;
    end
end

// Main LFSR logic
always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0001;  // Initialize to non-zero state
        cycle_counter <= 0;
    end
    else begin
        if (dir) begin
            // Right shift with feedback at MSB
            out <= {feedback_right, out[3:1]};
        end
        else begin
            // Left shift with feedback at LSB
            out <= {out[2:0], feedback_left};
        end
        
        // Increment cycle counter (mod 15)
        cycle_counter <= (cycle_counter == 14) ? 0 : cycle_counter + 1;
    end
end

// Detect when we've completed one full cycle (15 states)
assign cycle_complete = (cycle_counter == 14);

endmodule

module LFSR_tb;

reg clk;
reg rst;
reg dir;
reg fb_sel;
wire [3:0] out;
wire cycle_complete;

// Instantiate the LFSR
LFSR dut (
    .clk(clk),
    .rst(rst),
    .dir(dir),
    .fb_sel(fb_sel),
    .out(out),
    .cycle_complete(cycle_complete)
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
    dir = 0;
    fb_sel = 0;
    #10;
    
    // Release reset and test left shift with first polynomial
    rst = 0;
    $display("Testing left shift with x^4 + x^3 + 1 polynomial:");
    #150;  // Wait for one full cycle (15 states)
    
    // Switch to right shift
    dir = 1;
    $display("Testing right shift with x^4 + x^3 + 1 polynomial:");
    #150;
    
    // Change feedback polynomial
    fb_sel = 1;
    dir = 0;
    $display("Testing left shift with x^4 + x + 1 polynomial:");
    #150;
    
    // End simulation
    $display("Simulation complete");
    $finish;
end

// Monitor the output
initial begin
    $monitor("Time = %0t, State = %b, Cycle Complete = %b", $time, out, cycle_complete);
end

endmodule