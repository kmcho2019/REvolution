// Improved 4-bit LFSR with non-zero seed initialization on reset
module LFSR (
    input  wire       clk,
    input  wire       rst,      // Active high synchronous reset
    output reg  [3:0] out
);

    // Feedback is inversion of XOR of bits 3 and 2, per spec
    wire feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst) begin
            out <= 4'b0001;  // Non-zero seed to prevent lock-up on reset
        end else begin
            out <= {out[2:0], feedback};  // Shift left and insert feedback at LSB
        end
    end

endmodule

// Testbench with proper signal declarations and reset sequence
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

    // Clock generation: 10 time units period (100 MHz if time unit = 1ns)
    initial clk = 0;
    always #5 clk = ~clk;

    // Test stimulus
    initial begin
        // Initialize reset to active for a few cycles to initialize LFSR state
        rst = 1;
        #20;         // Hold reset for 2 clock cycles
        rst = 0;

        // Let the LFSR run for 200 time units (20 clock cycles)
        #200;

        // Apply reset again to verify proper re-initialization
        rst = 1;
        #10;
        rst = 0;

        // Run for additional cycles to observe re-seeding
        #100;

        // Finish simulation
        $finish;
    end

    // Display output for debug and verification
    initial begin
        $display("Time\t rst out");
        $monitor("%0t\t %b %b", $time, rst, out);
    end

endmodule