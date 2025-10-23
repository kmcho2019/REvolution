// LFSR module with synchronous active-high reset and inverted XOR feedback
module LFSR(
    input  wire       clk,
    input  wire       rst,  // synchronous active-high reset
    output reg  [3:0] out
);

    always @(posedge clk) begin
        if (rst) begin
            out <= 4'b0001;  // initialize to a non-zero state to start sequence
        end else begin
            // feedback is inverted XOR of bits 3 and 2 of current state
            out <= {out[2:0], ~(out[3] ^ out[2])};
        end
    end

endmodule

// Testbench for LFSR module
module tb_LFSR();

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

    initial begin
        // Initialize reset
        rst = 1;
        #12;       // hold reset for more than one clock cycle
        rst = 0;

        // Run simulation for 100 clock cycles
        #500;

        $finish;
    end

    // Monitor outputs on rising clock edge
    always @(posedge clk) begin
        $display("Time=%0t : rst=%b, out=%b", $time, rst, out);
    end

endmodule