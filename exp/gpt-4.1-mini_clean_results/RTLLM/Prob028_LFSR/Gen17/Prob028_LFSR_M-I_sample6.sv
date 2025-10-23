// 4-bit LFSR with feedback = inverted XOR of bits 3 and 2
// Synchronous active-high reset initializes to a non-zero seed to prevent lock-up.

module LFSR #(
    parameter [3:0] SEED = 4'b1001  // Non-zero seed default
)(
    input  wire       clk,
    input  wire       rst,      // synchronous active-high reset
    output reg  [3:0] out
);

    // Local parameters for bit indices used in feedback
    localparam integer MSB = 3;
    localparam integer BIT2 = 2;

    // Feedback calculation: inverted XOR of out[3] and out[2]
    wire feedback = ~(out[MSB] ^ out[BIT2]);

    // Next state by left shifting and inserting feedback at LSB
    wire [3:0] next_state = {out[MSB-1:0], feedback};

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (rst)
            out <= SEED;
        else
            out <= next_state;
    end

endmodule


// Simple testbench to demonstrate correct behavior
module tb_LFSR;

    reg clk = 0;
    reg rst = 0;
    wire [3:0] out;

    // Instantiate LFSR with default seed
    LFSR uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Clock generation: 10 time units period
    always #5 clk = ~clk;

    initial begin
        // Initialize and reset
        rst = 1;
        #15;
        rst = 0;

        // Run for 50 clock cycles to observe output
        repeat(50) @(posedge clk);

        $finish;
    end

    // Optional: monitor output for debugging
    initial begin
        $display("Time\tclk\trst\tout");
        $monitor("%0t\t%b\t%b\t%04b", $time, clk, rst, out);
    end

endmodule