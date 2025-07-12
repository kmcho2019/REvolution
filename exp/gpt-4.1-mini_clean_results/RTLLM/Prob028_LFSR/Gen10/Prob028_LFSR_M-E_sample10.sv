// 4-bit Fibonacci LFSR with right shift and feedback XOR of bits [0] and [1]
// Feedback is fed into the MSB, with synchronous active-high reset initializing to 4'b1000.

module LFSR (
    input  wire       clk,
    input  wire       rst,       // Active high synchronous reset
    output reg  [3:0] out
);

    wire feedback = out[0] ^ out[1];  // XOR of two least significant bits

    always @(posedge clk) begin
        if (rst)
            out <= 4'b1000;           // Non-zero seed to avoid lock-up
        else
            out <= {feedback, out[3:1]}; // Shift right, feed back to MSB
    end

endmodule

// Testbench for the right-shift Fibonacci LFSR
module tb_LFSR;

    reg clk;
    reg rst;
    wire [3:0] out;

    // Instantiate the LFSR
    LFSR uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Clock generation: 10 time unit period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Dump waves for waveform viewing
        $dumpfile("tb_LFSR.vcd");
        $dumpvars(0, tb_LFSR);

        $display("Time\t rst out");
        $monitor("%0t\t  %b  %b", $time, rst, out);

        // Initialize with reset active for 3 clock cycles
        rst = 1;
        repeat (3) @(posedge clk);
        rst = 0;

        // Run for 32 cycles to observe pseudo-random output sequence
        repeat (32) @(posedge clk);

        // Assert reset again to verify reset behavior
        rst = 1;
        @(posedge clk);
        @(posedge clk);
        rst = 0;

        // Run for additional 16 cycles after reset
        repeat (16) @(posedge clk);

        $finish;
    end

endmodule