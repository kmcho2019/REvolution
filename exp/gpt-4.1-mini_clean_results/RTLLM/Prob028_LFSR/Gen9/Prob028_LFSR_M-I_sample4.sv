// 4-bit LFSR with feedback as inverted XOR of bits 3 and 2.
// Synchronous active-high reset initializes the register to a non-zero seed to avoid lock-up.

module LFSR (
    input  wire       clk,
    input  wire       rst,      // Active high synchronous reset
    output reg  [3:0] out
);

    wire feedback = ~(out[3] ^ out[2]);  // Invert the XOR of bits 3 and 2

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0001;          // Initialize to non-zero seed on reset to enable maximal sequence
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
        // Optional waveform dump for simulators supporting it
        $dumpfile("LFSR_tb.vcd");
        $dumpvars(0, tb_LFSR);

        $display("Time\t rst out");
        $monitor("%0t\t  %b  %b", $time, rst, out);

        // Assert reset for 2 clock cycles to initialize LFSR
        rst = 1;
        @(posedge clk);
        @(posedge clk);
        rst = 0;

        // Let LFSR run for 40 clock cycles to observe pseudo-random sequence
        repeat (40) @(posedge clk);

        // Assert reset again to verify reset behavior and re-initialization
        rst = 1;
        @(posedge clk);
        @(posedge clk);
        rst = 0;

        // Run for additional 20 clock cycles
        repeat (20) @(posedge clk);

        $finish;
    end

endmodule