// 4-bit LFSR with feedback = inverted XOR of bits 3 and 2
// Synchronous active-high reset initializes to 4'b1111 (non-zero seed)

module LFSR (
    input  wire       clk,
    input  wire       rst,      // active high synchronous reset
    output reg  [3:0] out
);

    always_ff @(posedge clk) begin
        if (rst) begin
            out <= 4'b1111;  // Non-zero seed to avoid lock-up
        end else begin
            // Calculate feedback = inverted XOR of out[3] and out[2]
            // Insert feedback at LSB after shifting left
            out <= {out[2:0], ~(out[3] ^ out[2])};
        end
    end

endmodule


// Simple testbench for the LFSR module
module tb_LFSR();

    reg clk = 0;
    reg rst = 1;
    wire [3:0] out;

    // Instantiate LFSR
    LFSR dut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Clock generation: 10 time units period
    always #5 clk = ~clk;

    initial begin
        $display("Time\t rst out");
        $monitor("%0t\t %b   %b", $time, rst, out);

        // Release reset after two clock cycles
        #12;
        rst = 0;

        // Run for 20 clock cycles to observe sequence
        repeat (20) @(posedge clk);

        $finish;
    end

endmodule