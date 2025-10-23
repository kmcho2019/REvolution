module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] out
);

    // Parameterized reset value to avoid lock in zero state
    localparam [3:0] RESET_VALUE = 4'b0001;

    always @(posedge clk) begin
        if (rst)
            out <= RESET_VALUE;
        else
            out <= {out[2:0], ~(out[3] ^ out[2])};
    end

endmodule

// Updated testbench
module LFSR_tb;

    reg clk = 0;
    reg rst = 0;
    wire [3:0] out;

    LFSR uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // 10 time units clock period
    always #5 clk = ~clk;

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