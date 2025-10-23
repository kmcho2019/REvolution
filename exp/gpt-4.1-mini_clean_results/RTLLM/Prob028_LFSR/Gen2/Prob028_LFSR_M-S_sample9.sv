module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);
    wire feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0000;
        else
            out <= {out[2:0], feedback};
    end
endmodule

module LFSR_tb;
    reg clk = 0;
    reg rst = 1;
    wire [3:0] out;

    LFSR dut (.clk(clk), .rst(rst), .out(out));

    // Clock toggle every 5 time units
    always #5 clk = ~clk;

    initial begin
        #10 rst = 0;    // Release reset after 10 time units
        #100;
        rst = 1;       // Assert reset again to test
        #10 rst = 0;
        #50;
        $finish;
    end

    initial
        $monitor("Time=%0t clk=%b rst=%b out=%b", $time, clk, rst, out);
endmodule