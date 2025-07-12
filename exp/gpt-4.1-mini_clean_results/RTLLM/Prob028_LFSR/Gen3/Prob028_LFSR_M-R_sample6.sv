// 4-bit LFSR module with separated combinational next-state logic
module LFSR #(
    parameter INIT_VALUE = 4'b0001  // Non-zero seed on reset
) (
    input  wire       clk,
    input  wire       rst,    // synchronous active-high reset
    output reg [3:0]  out
);

    wire feedback;
    reg  [3:0] next_state;

    // Calculate feedback: inverted XOR of out[3] and out[2]
    assign feedback = ~(out[3] ^ out[2]);

    // Combinational logic for next state
    always @(*) begin
        // Shift left by one, inserting feedback at LSB
        next_state = {out[2:0], feedback};
    end

    // Sequential logic: register output on clock with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            out <= INIT_VALUE;  // Initialize to non-zero state
        end else begin
            out <= next_state;
        end
    end

endmodule


// Testbench for the LFSR module
`timescale 1ns/1ps
module tb_LFSR;

    reg clk_tb;
    reg rst_tb;
    wire [3:0] out_tb;

    // Instantiate the LFSR
    LFSR uut (
        .clk(clk_tb),
        .rst(rst_tb),
        .out(out_tb)
    );

    // Clock generation: 10 ns period
    initial clk_tb = 0;
    always #5 clk_tb = ~clk_tb;

    initial begin
        // Waveform dump for simulators that support it
        $dumpfile("tb_LFSR.vcd");
        $dumpvars(0, tb_LFSR);

        // Apply synchronous reset for a random duration between 10 and 30 ns
        rst_tb = 1;
        #(10 + $urandom_range(0,20));
        rst_tb = 0;

        // Run for 200 clock cycles
        repeat (200) @(posedge clk_tb);

        $finish;
    end

    // Display header
    initial begin
        $display("Time\t rst\t LFSR_out");
        $monitor("%0t\t %b\t %b", $time, rst_tb, out_tb);
    end

endmodule