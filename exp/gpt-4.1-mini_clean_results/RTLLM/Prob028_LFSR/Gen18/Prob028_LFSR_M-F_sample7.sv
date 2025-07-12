// LFSR module as originally specified
module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0000;
        else
            out <= {out[2:0], ~(out[3] ^ out[2])};
    end

endmodule


// Testbench for the LFSR module, fixing signal widths and declarations
module tb_LFSR;

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
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus
    initial begin
        // Initialize
        rst = 1;
        #12;
        rst = 0;
        // Let the LFSR run for some cycles
        #100;
        $finish;
    end

    // Display output changes
    initial begin
        $monitor("Time=%0t rst=%b out=%b", $time, rst, out);
    end

endmodule