// 4-bit Linear Feedback Shift Register (LFSR)
// Feedback = inverted XOR of bits 3 and 2, shifted left inserting feedback at LSB
// Reset initializes to 4'b0001 (non-zero seed) to avoid lock-up state

module LFSR (
    input wire clk,
    input wire rst,
    output reg [3:0] out
);

    // Compute feedback combinationally: feedback = ~(out[3] ^ out[2])
    wire feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst) begin
            out <= 4'b0001;  // Non-zero seed initialization to avoid lock-up at zero state
        end else begin
            out <= {out[2:0], feedback}; // Shift left and insert feedback at LSB
        end
    end

endmodule

// Testbench for LFSR module
module LFSR_tb;

    reg clk;
    reg rst;
    wire [3:0] out;

    // Instantiate the LFSR module
    LFSR uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Clock generation: 10 time units period
    initial clk = 0;
    always #5 clk = ~clk;

    // Test stimulus
    initial begin
        // Apply reset pulse
        rst = 1;
        #15;
        rst = 0;

        // Run for 100 clock cycles
        #1000;

        $finish;
    end

    // Monitor outputs
    initial begin
        $display("Time   rst out");
        $monitor("%4t   %b   %b", $time, rst, out);
    end

endmodule