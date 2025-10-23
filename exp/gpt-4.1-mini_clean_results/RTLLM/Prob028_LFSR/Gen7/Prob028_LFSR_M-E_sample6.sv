module LFSR (
    input  wire       clk,
    input  wire       rst,      // Active-high synchronous reset
    output reg  [3:0] out
);

    wire feedback = ~(out[3] ^ out[2]); // Inverted XOR feedback

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0000;           // Reset to zero as per specification
        else
            out <= {feedback, out[3:1]}; // Shift right, insert feedback at MSB
    end

endmodule


// Testbench to verify LFSR operation
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

    // Clock generation: 10 time units period
    initial clk = 0;
    always #5 clk = ~clk;

    // Test stimulus
    initial begin
        // Apply reset for 15 time units
        rst = 1;
        #15;
        rst = 0;

        // Run the LFSR for 50 clock cycles
        repeat (50) @(posedge clk);

        // Apply reset again to test reset behavior
        rst = 1;
        @(posedge clk);
        rst = 0;

        // Run for 20 more cycles
        repeat (20) @(posedge clk);

        $finish;
    end

    // Monitor outputs
    initial begin
        $display("Time\t rst out");
        $monitor("%0t\t  %b  %b", $time, rst, out);
    end

endmodule