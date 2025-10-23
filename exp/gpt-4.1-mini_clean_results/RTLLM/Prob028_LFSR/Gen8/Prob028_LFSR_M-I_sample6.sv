// 4-bit LFSR with synchronous reset and inverted XOR feedback
module LFSR (
    input  wire       clk,
    input  wire       rst,       // synchronous active-high reset
    output reg  [3:0] out
);

    always @(posedge clk) begin
        if (rst) begin
            out <= 4'b0000;       // initialize to zero as per problem statement
        end else begin
            // feedback = inverted XOR of out[3] and out[2]
            out <= {out[2:0], ~(out[3] ^ out[2])};
        end
    end

endmodule


// Testbench for the LFSR module
`timescale 1ns / 1ps
module tb_LFSR;

    reg        clk;
    reg        rst;
    wire [3:0] out;

    // Instantiate the LFSR module
    LFSR uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_LFSR.vcd");
        $dumpvars(0, tb_LFSR);

        // Apply reset synchronous to clock
        rst = 1;
        @(posedge clk);  // assert reset on rising clock edge
        rst = 0;

        // Run for 40 clock cycles after reset
        repeat (40) @(posedge clk);

        $finish;
    end

    // Monitor to observe outputs
    initial begin
        $display("Time(ns)\trst\tout");
        $monitor("%0t\t%b\t%b", $time, rst, out);
    end

endmodule