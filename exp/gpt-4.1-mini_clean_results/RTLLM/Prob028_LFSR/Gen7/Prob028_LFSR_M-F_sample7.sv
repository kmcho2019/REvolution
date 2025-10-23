// 4-bit LFSR module with synchronous active-high reset
module LFSR (
    input  wire       clk,
    input  wire       rst,       // synchronous active-high reset
    output reg  [3:0] out
);

    // Feedback is XOR of MSB (out[3]) and second MSB (out[2])
    wire feedback = out[3] ^ out[2];

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0001;      // non-zero seed to avoid lock-up at zero
        else
            out <= {out[2:0], feedback};
    end

endmodule


// Testbench for LFSR module
`timescale 1ns/1ps
module tb_LFSR;

    reg        clk;
    reg        rst;
    wire [3:0] out;

    // Instantiate the LFSR module under test
    LFSR uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Clock generation: 10ns period (100MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    // Stimulus block
    initial begin
        $dumpfile("tb_LFSR.vcd");
        $dumpvars(0, tb_LFSR);

        // Apply synchronous reset for one clock cycle
        rst = 1;
        @(posedge clk);
        rst = 0;

        // Run simulation for 50 clock cycles after reset deassertion
        repeat (50) @(posedge clk);

        $finish;
    end

    // Monitor signals for debugging
    initial begin
        $display("Time(ns)\t rst out");
        $monitor("%0t\t %b   %b", $time, rst, out);
    end

endmodule