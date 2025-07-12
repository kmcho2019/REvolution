// Novel LFSR design in Galois configuration
module LFSR(
    input           clk,       // Clock signal
    input           rst,       // Active high reset signal
    output reg [3:0] out       // 4-bit output representing the current state of the LFSR
);

// Polynomial: x^4 + x + 1
// Taps: 4, 1, and 0

always @(posedge clk or posedge rst) begin
    if (rst) begin // Reset condition: initialize output to zero
        out <= 4'b1; // Initialize with a non-zero value for maximum-length sequence
    end else begin // Normal operation: update LFSR state
        // Calculate feedback using the Galois configuration
        reg [3:0] next_state;
        next_state = out;
        next_state[3] = out[0] ^ out[2]; // Feedback from bits 0 and 2
        out <= next_state;
    end
end

endmodule

// Testbench for the novel LFSR module
module LFSR_tb;
    reg clk;         // Clock signal
    reg rst;         // Reset signal
    wire [3:0] out;  // Output from the LFSR module

    // Instantiate the LFSR module
    LFSR lfsr_instance(
     .clk(clk),
     .rst(rst),
     .out(out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever begin
            #5; // Clock period is 10 units (5 for high, 5 for low)
            clk = ~clk;
        end
    end

    // Test sequence
    initial begin
        rst = 1; // Start with reset high
        #10;    // Hold reset high for a clock cycle
        rst = 0; // Release reset
        #1000;   // Run for 1000 time units to observe the pseudo-random sequence
        $finish;
    end

endmodule