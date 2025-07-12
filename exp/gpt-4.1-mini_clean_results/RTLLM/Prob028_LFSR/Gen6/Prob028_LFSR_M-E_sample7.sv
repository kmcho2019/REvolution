// 4-bit LFSR module using polynomial x^4 + x + 1 (taps on bits 3 and 1)
// Synchronous active-high reset initializes to 4'b0001 (nonzero seed)

module LFSR (
    input  wire       clk,
    input  wire       rst,      // active high synchronous reset
    output wire [3:0] out
);

    reg [3:0] state;

    // Function to calculate next state based on current state
    function [3:0] next_lfsr_state(input [3:0] current);
        reg feedback;
        begin
            // Feedback = XOR of bit 3 and bit 1
            feedback = current[3] ^ current[1];
            // Shift left and insert feedback at LSB
            next_lfsr_state = {current[2:0], feedback};
        end
    endfunction

    always @(posedge clk) begin
        if (rst)
            state <= 4'b0001;  // Non-zero initial seed
        else
            state <= next_lfsr_state(state);
    end

    assign out = state;

endmodule


// Minimal testbench for 4-bit LFSR
module tb_LFSR();

    reg clk;
    reg rst;
    wire [3:0] out;

    // Instantiate LFSR
    LFSR dut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Clock generation: 10 time units period
    initial clk = 0;
    always #5 clk = ~clk;

    integer i;

    initial begin
        // Initialize
        rst = 1;
        #10;
        rst = 0;

        $display("Time\t rst out");
        $monitor("%0t\t %b   %b", $time, rst, out);

        // Run for 20 clock cycles after reset deasserted
        for (i = 0; i < 20; i = i + 1) begin
            @(posedge clk);
        end

        $finish;
    end

endmodule