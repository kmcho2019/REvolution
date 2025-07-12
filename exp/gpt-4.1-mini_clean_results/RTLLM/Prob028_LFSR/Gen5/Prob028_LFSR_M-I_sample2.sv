// 4-bit LFSR with standard maximal-length taps (bits 3 and 2 XORed as feedback)
// Active-high asynchronous reset initializes LFSR to 4'b0001 to avoid all-zero lock state.

module LFSR (
    input  wire       clk,
    input  wire       rst_n,    // Active low asynchronous reset
    output reg  [3:0] out
);

    wire feedback = out[3] ^ out[2];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            out <= 4'b0001;          // Nonzero seed to avoid lock-up
        else
            out <= {out[2:0], feedback};
    end

endmodule

// Testbench for LFSR module
module tb_LFSR;

    reg clk;
    reg rst_n;
    wire [3:0] out;

    // Instantiate DUT
    LFSR uut (
        .clk(clk),
        .rst_n(rst_n),
        .out(out)
    );

    // Clock: 10 time units period
    initial clk = 0;
    always #5 clk = ~clk;

    // Test stimulus
    initial begin
        // Initialize reset
        rst_n = 0;
        #20;
        rst_n = 1;

        // Let LFSR run for 200 cycles
        repeat (200) @(posedge clk);

        // Apply reset again briefly
        rst_n = 0;
        #15;
        rst_n = 1;

        // Run some more cycles
        repeat (50) @(posedge clk);

        $finish;
    end

    // Monitor output
    initial begin
        $display("Time\t rst_n out");
        $monitor("%0t\t %b    %b", $time, rst_n, out);
    end

endmodule