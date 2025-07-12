// 4-bit LFSR module with synchronous active-high reset and inverted XOR feedback
module LFSR(
    input  wire       clk,
    input  wire       rst,    // synchronous active-high reset
    output reg  [3:0] out
);

    always @(posedge clk) begin
        if (rst) begin
            out <= 4'b0001;  // non-zero seed to start LFSR sequence
        end else begin
            out <= {out[2:0], ~(out[3] ^ out[2])};  // shift left, insert feedback bit
        end
    end

endmodule


// Testbench for the LFSR module
module tb_LFSR();

    reg        clk;
    reg        rst;
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
        // Initialize reset: asserted for a few cycles, then released
        rst = 1;
        #(12);     // hold reset for >1 clock cycle
        rst = 0;

        // Let the LFSR run for sufficient cycles to observe pseudo-random sequence
        #(500);

        $finish;
    end

    // Monitor LFSR output on rising clock edge
    always @(posedge clk) begin
        $display("Time=%0t rst=%b out=%b", $time, rst, out);
    end

endmodule