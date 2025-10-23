module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    // Galois LFSR implementation with taps at bits 3 and 2 (polynomial x^4 + x^3 + 1)
    // Feedback is implicitly applied by XORing the MSB into certain bits

    always @(posedge clk) begin
        if (rst) begin
            out <= 4'b0001; // Non-zero seed to avoid lock-up
        end else begin
            // Save MSB before shift
            // Bit indexing: out[3] is MSB, out[0] is LSB
            wire msb = out[3];

            // Shift and apply taps:
            // new out[3] = out[2]
            // new out[2] = out[1] ^ msb
            // new out[1] = out[0]
            // new out[0] = msb
            out[3] <= out[2];
            out[2] <= out[1] ^ msb;
            out[1] <= out[0];
            out[0] <= msb;
        end
    end

endmodule


// Testbench for Galois LFSR
module tb_LFSR;

    reg clk;
    reg rst;
    wire [3:0] out;

    // Instantiate the LFSR module
    LFSR uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Generate clock with a period of 10 time units
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $display("Time\tclk\trst\tout");
        $monitor("%0t\t%b\t%b\t%04b", $time, clk, rst, out);
    end

    initial begin
        rst = 1;         // Assert reset
        #12;             // Hold reset for a bit more than one clock cycle
        rst = 0;         // Release reset

        // Run for 100 clock cycles to observe the sequence
        repeat (100) @(posedge clk);

        $finish;         // End simulation
    end

    // Check if the LFSR locks to zero (should not happen with non-zero seed)
    always @(posedge clk) begin
        if (!rst && out == 4'b0000) begin
            $display("Error: LFSR locked to zero state at time %0t!", $time);
        end
    end

endmodule