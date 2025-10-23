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

// Simple testbench to verify functionality
module LFSR_tb;

    reg clk = 0;
    reg rst = 0;
    wire [3:0] out;

    LFSR uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    always #5 clk = ~clk;  // 10 time units clock period

    initial begin
        rst = 1;
        #10;
        rst = 0;

        repeat (50) @(posedge clk);

        $finish;
    end

    initial begin
        $monitor("Time=%0t | rst=%b | out=%b", $time, rst, out);
    end

endmodule