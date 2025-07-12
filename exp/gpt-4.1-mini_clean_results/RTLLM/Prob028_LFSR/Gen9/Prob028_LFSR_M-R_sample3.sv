module LFSR (
    input  wire       clk,
    input  wire       rst,    // Synchronous active high reset
    output reg  [3:0] out
);

    reg feedback;

    // Compute feedback bit combinationally
    always @(*) begin
        feedback = ~(out[3] ^ out[2]);
    end

    // Sequential state update with synchronous reset
    always @(posedge clk) begin
        if (rst)
            out <= 4'b0001;  // Non-zero seed to avoid lockup
        else
            out <= {out[2:0], feedback};
    end

endmodule


// Testbench for the LFSR module
module LFSR_tb;

    reg clk;
    reg rst;
    wire [3:0] out;

    // Instantiate the LFSR
    LFSR uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Clock generation: 10 time unit period
    initial clk = 0;
    always #5 clk = ~clk;

    // Stimulus
    initial begin
        rst = 1;       // Assert reset initially
        #12;
        rst = 0;       // Deassert reset

        // Run for a number of cycles to observe the LFSR sequence
        #200;

        $finish;
    end

    // Monitoring output
    initial begin
        $display("Time\t rst out");
        $monitor("%4t\t %b   %b", $time, rst, out);
    end

endmodule