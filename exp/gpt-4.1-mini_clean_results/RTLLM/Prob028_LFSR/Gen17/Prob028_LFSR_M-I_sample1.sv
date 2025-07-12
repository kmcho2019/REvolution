// LFSR module as specified
module LFSR #(
    parameter [3:0] SEED = 4'b1001  // Non-zero seed to avoid lock-up
)(
    input  wire       clk,
    input  wire       rst,     // synchronous active-high reset
    output reg  [3:0] out
);

    // Bit indices for feedback calculation
    localparam integer MSB  = 3;
    localparam integer BIT2 = 2;

    // Feedback: inverted XOR of bits 3 and 2 of current state
    wire feedback = ~(out[MSB] ^ out[BIT2]);

    // Next state: shift left by one, insert feedback at LSB
    wire [3:0] next_state = {out[MSB-1:0], feedback};

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            out <= SEED;
        end else begin
            out <= next_state;
        end
    end

endmodule


// Minimal testbench to verify LFSR functionality
module tb_LFSR;
    reg        clk;
    reg        rst;
    wire [3:0] out;

    // Instantiate the LFSR module
    LFSR dut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Clock generation: 10 time units period
    initial clk = 0;
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize reset
        rst = 1;
        #12;        // Hold reset for more than one clock cycle
        rst = 0;

        // Run for 30 clock cycles and monitor output
        repeat (30) @(posedge clk);

        // Finish simulation
        $finish;
    end

    // Monitor output changes
    initial begin
        $display("Time\t rst\t out");
        $monitor("%0t\t %b\t %b", $time, rst, out);
    end

endmodule