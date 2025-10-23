// 4-bit LFSR module with clean combinational and sequential logic
module LFSR #(
    parameter INIT_VALUE = 4'b0001  // Non-zero seed on reset
) (
    input  wire       clk,    // 1-bit clock input
    input  wire       rst,    // 1-bit synchronous active-high reset
    output reg  [3:0] out     // 4-bit output state
);

    wire feedback;
    reg  [3:0] next_state;

    // Feedback = inverted XOR of MSB and next MSB bits
    assign feedback = ~(out[3] ^ out[2]);

    // Next state calculation (combinational)
    always @(*) begin
        next_state = {out[2:0], feedback};  // Shift left + feedback at LSB
    end

    // Sequential logic: state update with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            out <= INIT_VALUE;  // Initialize to non-zero value on reset
        end else begin
            out <= next_state;
        end
    end

endmodule


// Simple testbench to validate the LFSR
`timescale 1ns/1ps
module tb_LFSR;

    reg clk_tb;
    reg rst_tb;
    wire [3:0] out_tb;

    // Instantiate the LFSR module
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
        // Optional waveform dump for GTKWave or similar
        $dumpfile("tb_LFSR.vcd");
        $dumpvars(0, tb_LFSR);

        // Apply synchronous reset for 2 clock cycles
        rst_tb = 1;
        @(posedge clk_tb);
        @(posedge clk_tb);
        rst_tb = 0;

        // Run the LFSR for 50 clock cycles
        repeat (50) @(posedge clk_tb);

        // Finish simulation
        $finish;
    end

    // Monitor signals
    initial begin
        $display("Time(ns)  rst_tb  LFSR_out");
        $monitor("%8t    %b       %b", $time, rst_tb, out_tb);
    end

endmodule