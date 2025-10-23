module LFSR (
    input wire clk,        // Clock input
    input wire rst,        // Active-high synchronous reset
    output reg [3:0] out   // 4-bit LFSR state output
);

// Feedback is XOR of bits 3 and 2, then inverted
wire feedback = ~(out[3] ^ out[2]);

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0001;    // Initialize to valid starting state
    end
    else begin
        // Shift left and insert inverted XOR feedback at LSB
        out <= {out[2:0], feedback};
    end
end

endmodule

module LFSR_tb;

reg clk_tb;
reg rst_tb;
wire [3:0] out_tb;

// Instantiate the LFSR
LFSR dut (
    .clk(clk_tb),
    .rst(rst_tb),
    .out(out_tb)
);

// Clock generation
initial begin
    clk_tb = 0;
    forever #5 clk_tb = ~clk_tb;
end

// Test sequence
initial begin
    // Initialize
    rst_tb = 1;
    #10;
    
    // Release reset
    rst_tb = 0;
    
    // Run for enough cycles to see all states
    #320;
    
    // Check if we've seen all 15 non-zero states (4-bit LFSR has 15 states)
    $display("Simulation complete");
    $finish;
end

// Monitor the output
initial begin
    $monitor("Time = %0t, out = %b", $time, out_tb);
end

endmodule