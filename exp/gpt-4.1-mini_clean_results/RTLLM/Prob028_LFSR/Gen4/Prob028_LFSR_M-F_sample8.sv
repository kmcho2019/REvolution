// LFSR module (unchanged)
module LFSR (
    input  wire       clk,
    input  wire       rst,      // Active high synchronous reset
    output reg  [3:0] out
);

    // Feedback is inversion of XOR of bits 3 and 2
    wire feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst) begin
            out <= 4'b0000;  // Initialize to zero on reset
        end else begin
            out <= {out[2:0], feedback};  // Shift left and insert feedback at LSB
        end
    end

endmodule

// Testbench with correct signal declarations and port connections
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
        // Initialize reset
        rst = 1;
        #15;
        rst = 0;

        // Let the LFSR run for some cycles
        #100;

        // Apply reset again to test
        rst = 1;
        #10;
        rst = 0;
        #50;

        // Finish simulation
        $finish;
    end

    // Optional: display output for verification
    initial begin
        $monitor("At time %0t: rst=%b, out=%b", $time, rst, out);
    end

endmodule