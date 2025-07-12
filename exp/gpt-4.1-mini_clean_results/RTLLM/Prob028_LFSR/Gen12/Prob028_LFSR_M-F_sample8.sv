// 4-bit LFSR module with inverted XOR feedback from bits [3] and [2]
module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    wire feedback;
    assign feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0000;
        else
            out <= {out[2:0], feedback};
    end

endmodule


// Testbench for the LFSR module
module tb_LFSR;

    reg clk_tb;
    reg rst_tb;
    wire [3:0] out_tb;

    // Instantiate the LFSR module
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

    // Test stimulus
    initial begin
        // Initialize signals
        rst_tb = 1;       // Assert reset
        #12;              // Hold reset for slightly more than one clock cycle
        rst_tb = 0;       // Deassert reset to start LFSR shifting

        // Run for a number of cycles to observe pseudo-random output
        #100;

        // Finish simulation
        $finish;
    end

    // Optional: monitor outputs for verification
    initial begin
        $monitor("Time=%0t | rst=%b | out=%b", $time, rst_tb, out_tb);
    end

endmodule