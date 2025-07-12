// 4-bit LFSR with feedback as inverted XOR of bits 3 and 2.
// Synchronous active-high reset initializes the register to 4'b0000 as specified.

module LFSR (
    input  wire       clk,
    input  wire       rst,      // Active high synchronous reset
    output reg  [3:0] out
);

    wire feedback = ~(out[3] ^ out[2]);  // Invert the XOR of bits 3 and 2

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0000;          // Initialize to zero on reset as per spec
        else
            out <= {out[2:0], feedback};
    end

endmodule

// Testbench for LFSR module
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

    // Generate clock: 10 time units period
    initial clk = 0;
    always #5 clk = ~clk;

    // Test stimulus
    initial begin
        $display("Time\t rst out");
        $monitor("%0t\t  %b  %b", $time, rst, out);

        // Initial reset asserted for 2 clock cycles
        rst = 1;
        @(posedge clk);
        @(posedge clk);
        rst = 0;

        // Let LFSR run for 30 clock cycles
        repeat (30) @(posedge clk);

        // Assert reset again for 2 clock cycles to verify reset works
        rst = 1;
        @(posedge clk);
        @(posedge clk);
        rst = 0;

        // Run for additional 10 clock cycles
        repeat (10) @(posedge clk);

        $finish;
    end

endmodule