// 4-bit LFSR with feedback as XOR of bits 3 and 2 (no inversion).
// Synchronous active-high reset initializes the register to 4'b0001 to avoid all-zero lock state.

module LFSR (
    input  wire       clk,
    input  wire       rst,      // Active high synchronous reset
    output reg  [3:0] out
);

    wire feedback = out[3] ^ out[2];

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0001;          // Nonzero seed on reset
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
        // Initialize inputs
        rst = 1;
        #12;       // Hold reset for a bit more than one clock cycle
        rst = 0;

        // Let LFSR run for 100 clock cycles
        repeat (100) @(posedge clk);

        // Apply reset again
        rst = 1;
        @(posedge clk);
        rst = 0;

        // Run for some more cycles
        repeat (20) @(posedge clk);

        $finish;
    end

    // Monitor output values
    initial begin
        $display("Time\t rst out");
        $monitor("%0t\t  %b  %b", $time, rst, out);
    end

endmodule