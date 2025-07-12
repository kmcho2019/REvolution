module LFSR (
    input  wire       clk,
    input  wire       rst,    // Active high synchronous reset
    output reg  [3:0] out
);

    // Compute next state bits from current out bits
    // Using polynomial x^4 + x^3 + 1 (taps at bits 3 and 2)
    // next[3] = out[2]
    // next[2] = out[1]
    // next[1] = out[0] ^ out[3]
    // next[0] = out[3]

    wire n3 = out[2];
    wire n2 = out[1];
    wire n1 = out[0] ^ out[3];
    wire n0 = out[3];

    always @(posedge clk) begin
        if (rst)
            out <= 4'b1001;  // Nonzero seed to avoid lockup
        else
            out <= {n3, n2, n1, n0};
    end

endmodule


// Testbench for LFSR with parallel feedback logic
module tb_LFSR;

    reg clk;
    reg rst;
    wire [3:0] out;

    LFSR uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock period 10 time units
    end

    initial begin
        rst = 1;
        #15;
        rst = 0;

        // Run for 50 cycles after reset deassertion
        repeat (50) @(posedge clk);

        // Apply reset again for 10 cycles
        rst = 1;
        repeat (10) @(posedge clk);
        rst = 0;

        // Run 20 more cycles
        repeat (20) @(posedge clk);

        $finish;
    end

    initial begin
        $dumpfile("lfsr_parallel.vcd");
        $dumpvars(0, tb_LFSR);

        $display("Time  rst out");
        $monitor("%0t    %b   %b", $time, rst, out);
    end

endmodule