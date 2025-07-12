module LFSR (
    input  wire       clk,
    input  wire       rst,      // Active-high synchronous reset
    output reg  [3:0] out
);

    // Feedback is inverted XOR of bits 3 and 2
    wire feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0000;            // Reset to zero
        else
            out <= {feedback, out[3:1]}; // Shift right, insert feedback at MSB
    end

endmodule


// Clean testbench for LFSR with correct signal widths and assignments
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

    // Clock generation: 10 time unit period
    initial clk = 0;
    always #5 clk = ~clk;

    // Test stimulus
    initial begin
        // Initially assert reset to zero LFSR
        rst = 1;
        #15;           // Hold reset for a few clock cycles
        rst = 0;

        // Let LFSR run for 50 clock cycles
        repeat (50) @(posedge clk);

        // Assert reset again to check reset functionality
        rst = 1;
        @(posedge clk);
        rst = 0;

        // Run for 20 more clock cycles
        repeat (20) @(posedge clk);

        $finish;
    end

    // Display header and monitor outputs
    initial begin
        $display("Time\t rst out");
        $monitor("%0t\t  %b  %b", $time, rst, out);
    end

endmodule