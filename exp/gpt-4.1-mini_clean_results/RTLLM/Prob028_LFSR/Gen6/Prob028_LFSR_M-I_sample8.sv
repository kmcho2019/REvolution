// 4-bit Linear Feedback Shift Register (LFSR)
// Feedback = inverted XOR of bits 3 and 2, shifted left inserting feedback at LSB
// Synchronous reset initializes to a non-zero seed to avoid lock-up state

module LFSR #(
    parameter WIDTH = 4,
    parameter INIT_SEED = 4'b0001  // Non-zero initial seed
)(
    input  wire clk,
    input  wire rst,    // Active high synchronous reset
    output reg  [WIDTH-1:0] out
);

    // Feedback calculated as inverted XOR of MSB and bit below MSB
    wire feedback = ~(out[WIDTH-1] ^ out[WIDTH-2]);

    always @(posedge clk) begin
        if (rst) begin
            out <= INIT_SEED;
        end else begin
            out <= {out[WIDTH-2:0], feedback};  // Shift left and insert feedback at LSB
        end
    end

endmodule

// Testbench for the LFSR module
module LFSR_tb;

    // Parameters
    localparam WIDTH = 4;
    localparam CLK_PERIOD = 10;

    // Testbench signals
    reg clk;
    reg rst;
    wire [WIDTH-1:0] out;

    // Instantiate LFSR
    LFSR #(
        .WIDTH(WIDTH),
        .INIT_SEED(4'b0001)
    ) uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Clock generation
    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    // Test stimulus
    initial begin
        // Initialize
        rst = 1;
        #(CLK_PERIOD*3);  // Hold reset for 3 clock cycles

        rst = 0;
        // Run for 40 clock cycles to observe full LFSR sequence
        #(CLK_PERIOD*40);

        $finish;
    end

    // Monitor outputs
    initial begin
        $display("Time  clk rst out");
        $monitor("%4t   %b   %b   %b", $time, clk, rst, out);
    end

endmodule