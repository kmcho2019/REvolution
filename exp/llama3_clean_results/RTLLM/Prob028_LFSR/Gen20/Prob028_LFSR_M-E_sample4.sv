// Novel Galois LFSR module
module LFSR_Galois(
    input           clk,       // Clock signal
    input           rst,       // Active high reset signal
    output reg [3:0] out       // 4-bit output representing the current state of the LFSR
);

// Sequential logic block to update the LFSR state
always @(posedge clk or posedge rst) begin
    if (rst) begin // Reset condition: initialize output to zero
        out <= 4'b1; // Initialize with a non-zero state for maximum length sequence
    end else begin // Normal operation: update LFSR state
        // Update state based on the polynomial x^4 + x + 1
        // For a 4-bit LFSR, this means out[0] = out[3] ^ out[0]
        out <= {out[2:0], out[3] ^ out[0]};
    end
end

endmodule

// Testbench for the Galois LFSR module
module LFSR_Galois_tb;
    reg clk;         // Clock signal
    reg rst;         // Reset signal
    wire [3:0] out;  // Output from the LFSR module

    // Instantiate the Galois LFSR module
    LFSR_Galois lfsr_galois_instance(
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
        #200;   // Run for 200 time units to observe the sequence
        $finish;
    end

endmodule