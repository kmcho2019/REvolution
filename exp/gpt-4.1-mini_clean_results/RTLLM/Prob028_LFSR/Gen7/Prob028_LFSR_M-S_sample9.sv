module LFSR (
    input  wire clk,
    input  wire rst,        // Active high synchronous reset
    output reg  [3:0] out
);

    wire feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0000;
        else
            out <= {out[2:0], feedback};
    end

endmodule

// Simple testbench
module LFSR_tb;
    reg clk = 0;
    reg rst = 1;
    wire [3:0] out;

    LFSR uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    always #5 clk = ~clk;

    initial begin
        #12 rst = 0;
        #100 $finish;
    end

    initial begin
        $monitor("Time=%0t clk=%b rst=%b out=%b", $time, clk, rst, out);
    end
endmodule