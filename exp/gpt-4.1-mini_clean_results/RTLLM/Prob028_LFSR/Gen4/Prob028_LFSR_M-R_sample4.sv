module LFSR (
    input  wire clk,
    input  wire rst,      // synchronous active-high reset
    output reg  [3:0] out
);

    // Combinational logic for feedback: inverted XOR of out[3] and out[2]
    wire feedback;
    assign feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0001;  // non-zero initial seed
        else
            out <= {out[2:0], feedback};
    end

endmodule


// Testbench for the refactored LFSR module
`timescale 1ns/1ps
module tb_LFSR;

    reg clk;
    reg rst;
    wire [3:0] out;

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

        // Apply synchronous reset
        rst = 1;
        #10;
        rst = 0;

        // Run simulation for 100 clock cycles
        repeat (100) @(posedge clk);

        $finish;
    end

    initial begin
        $display("Time\t rst\t LFSR_out");
        $monitor("%0t\t %b\t %b", $time, rst, out);
    end

endmodule