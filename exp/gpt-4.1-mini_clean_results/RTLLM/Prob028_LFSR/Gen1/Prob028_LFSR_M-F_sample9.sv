// Corrected LFSR module (unchanged as it is correct)
module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
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


// Fixed testbench to properly drive inputs and match port widths
module LFSR_testbench;

    reg clk_tb;              // clk must be reg to drive it
    reg rst_tb;              // rst must be reg to drive it
    wire [3:0] out_tb;      // out is wire with correct width

    // Instantiate the LFSR module
    LFSR dut (
        .clk(clk_tb),
        .rst(rst_tb),
        .out(out_tb)
    );

    // Clock generation: 10 time unit period
    initial begin
        clk_tb = 0;
        forever #5 clk_tb = ~clk_tb;
    end

    // Test sequence
    initial begin
        // Initialize reset
        rst_tb = 1;
        #20;
        rst_tb = 0;

        // Let the LFSR run for a while
        #100;

        // Optionally assert reset again to test reset behavior
        rst_tb = 1;
        #10;
        rst_tb = 0;

        #50;

        // Finish simulation
        $finish;
    end

    // Optional: monitor output changes
    initial begin
        $monitor("Time=%0t clk=%b rst=%b out=%b", $time, clk_tb, rst_tb, out_tb);
    end

endmodule