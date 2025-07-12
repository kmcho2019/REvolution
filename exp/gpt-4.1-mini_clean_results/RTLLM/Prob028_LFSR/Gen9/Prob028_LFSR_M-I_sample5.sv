// Optimized 4-bit LFSR with asynchronous active-high reset and combinational feedback logic
module LFSR (
    input  wire       clk,
    input  wire       rst,      // asynchronous active-high reset
    output reg  [3:0] out
);

    wire feedback;
    assign feedback = out[3] ^ out[2];

    always @(posedge clk or posedge rst) begin
        if (rst)
            out <= 4'b0001;           // non-zero seed to avoid lock-up
        else
            out <= {out[2:0], feedback};
    end

endmodule


// Testbench for the optimized LFSR
`timescale 1ns / 1ps
module tb_LFSR;

    reg        clk;
    reg        rst;
    wire [3:0] out;

    // Instantiate the LFSR
    LFSR uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Clock generation: 10ns period (100 MHz)
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // Stimulus
    initial begin
        $dumpfile("tb_LFSR.vcd");
        $dumpvars(0, tb_LFSR);

        // Initialize reset active
        rst = 1;
        #12;           // hold reset for 12ns (one full clock + some margin)

        rst = 0;       // release reset

        // Run for 50 clock cycles after reset release
        repeat (50) @(posedge clk);

        $finish;
    end

    // Monitor output and reset signals
    initial begin
        $display("Time(ns)  rst  LFSR_out");
        $monitor("%0t      %b    %b", $time, rst, out);
    end

endmodule