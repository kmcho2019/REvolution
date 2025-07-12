module TopModule (
    input  clk,
    input  d,
    output reg q
);

    reg clk_dly;
    wire clk_2x;

    // Delay the clock by one cycle (using a flip-flop)
    always @(posedge clk) begin
        clk_dly <= clk;
    end

    // XOR current clk and delayed clk to create a frequency doubled clock
    assign clk_2x = clk ^ clk_dly;

    // Use the doubled frequency clock to sample input d on both edges of the original clk
    always @(posedge clk_2x) begin
        q <= d;
    end

endmodule