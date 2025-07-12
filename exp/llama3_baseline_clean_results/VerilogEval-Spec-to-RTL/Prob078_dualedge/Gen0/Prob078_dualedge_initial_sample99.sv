module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_rising, q_falling;

always @(posedge clk)
    q_rising <= d;

always @(negedge clk)
    q_falling <= d;

always @(*)
    q <= (clk) ? q_rising : q_falling;

endmodule