// LFSR module with synchronous reset and feedback
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


// Testbench for the LFSR module
module tb_LFSR;

    reg clk_tb;
    reg rst_tb;
    wire [3:0] out_tb;

    // Instantiate LFSR
    LFSR uut (
        .clk(clk_tb),
        .rst(rst_tb),
        .out(out_tb)
    );

    // Clock generation: 10 time units period
    initial begin
        clk_tb = 0;
        forever #5 clk_tb = ~clk_tb;
    end

    // Stimulus
    initial begin
        // Initialize reset
        rst_tb = 1;
        #15;          // hold reset for some cycles
        rst_tb = 0;   // release reset

        // Run for 100 clock cycles
        repeat (100) @(posedge clk_tb);

        // Finish simulation
        $finish;
    end

    // Monitor output on each clock edge
    initial begin
        $display("Time\t rst\t LFSR_out");
        $monitor("%0t\t %b\t %b", $time, rst_tb, out_tb);
    end

endmodule