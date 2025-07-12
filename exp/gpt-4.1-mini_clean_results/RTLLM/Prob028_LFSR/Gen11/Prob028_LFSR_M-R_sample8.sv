module LFSR (
    input  wire       clk,
    input  wire       rst_n,   // active-low asynchronous reset
    output reg  [3:0] out
);

    wire feedback;
    assign feedback = ~(out[3] ^ out[2]);

    // Asynchronous reset to a non-zero seed (e.g. 4'b0001) to avoid lock-up in zero state.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            out <= 4'b0001;       // Initial seed instead of zero
        else
            out <= {out[2:0], feedback};
    end

endmodule


// Testbench with asynchronous active-low reset adapted for new LFSR
module tb_LFSR();

    reg clk;
    reg rst_n;
    wire [3:0] out;

    LFSR dut (
        .clk(clk),
        .rst_n(rst_n),
        .out(out)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Apply reset
        rst_n = 0;
        #15;
        rst_n = 1;

        // Run for 150 ns to observe sequence
        #150;

        // Assert reset again asynchronously
        rst_n = 0;
        #10;
        rst_n = 1;

        #50;

        $finish;
    end

    initial begin
        $display("Time\tclk\trst_n\tout");
        $monitor("%0dns\t%b\t%b\t%04b", $time, clk, rst_n, out);
    end

endmodule