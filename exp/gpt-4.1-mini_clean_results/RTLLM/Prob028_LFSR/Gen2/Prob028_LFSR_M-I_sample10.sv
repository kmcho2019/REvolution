// 4-bit LFSR module with parameterized initial value and feedback taps
module LFSR #(
    parameter INIT_VALUE = 4'b0001  // Non-zero seed value on reset
) (
    input  wire clk,
    input  wire rst,     // synchronous active-high reset
    output reg  [3:0] out
);

    // Feedback is inverted XOR of MSB and second MSB as per requirement
    wire feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst) begin
            out <= INIT_VALUE; // Avoid all-zero lockup state
        end else begin
            out <= {out[2:0], feedback};
        end
    end

endmodule


// Testbench for the LFSR module
`timescale 1ns/1ps
module tb_LFSR;

    reg clk_tb;
    reg rst_tb;
    wire [3:0] out_tb;

    // Instantiate LFSR with default INIT_VALUE=4'b0001
    LFSR uut (
        .clk(clk_tb),
        .rst(rst_tb),
        .out(out_tb)
    );

    // Clock generation: 10 ns period
    initial clk_tb = 0;
    always #5 clk_tb = ~clk_tb;

    // Test stimulus
    initial begin
        // Initialize waveform dump for supported simulators
        $dumpfile("tb_LFSR.vcd");
        $dumpvars(0, tb_LFSR);

        // Hold reset for random cycles between 10 and 30 ns to check robustness
        rst_tb = 1;
        #(10 + $urandom_range(0,20));
        rst_tb = 0;

        // Run LFSR for 200 clock cycles
        repeat (200) @(posedge clk_tb);

        // Finish simulation cleanly
        $finish;
    end

    // Monitor output values on clock edges for debug
    initial begin
        $display("Time\t rst\t LFSR_out");
        $monitor("%0t\t %b\t %b", $time, rst_tb, out_tb);
    end

endmodule