// Refactored 4-bit LFSR with synchronous reset and combinational feedback logic
module LFSR (
    input  wire       clk,
    input  wire       rst,      // synchronous active-high reset
    output wire [3:0] out
);

    reg [3:0] lfsr_reg;
    wire      feedback;

    // Feedback calculated as XOR of bits [3] and [2]
    assign feedback = lfsr_reg[3] ^ lfsr_reg[2];

    always @(posedge clk) begin
        if (rst)
            lfsr_reg <= 4'b0001;           // seed non-zero to avoid lock-up
        else
            lfsr_reg <= {lfsr_reg[2:0], feedback};
    end

    assign out = lfsr_reg;

endmodule


// Testbench for the refactored LFSR
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

        // Apply reset for one clock cycle
        rst = 1;
        @(posedge clk);
        rst = 0;

        // Run for 50 clock cycles after reset
        repeat (50) @(posedge clk);

        $finish;
    end

    // Monitor output and reset signals
    initial begin
        $display("Time(ns)  rst  LFSR_out");
        $monitor("%0t      %b    %b", $time, rst, out);
    end

endmodule