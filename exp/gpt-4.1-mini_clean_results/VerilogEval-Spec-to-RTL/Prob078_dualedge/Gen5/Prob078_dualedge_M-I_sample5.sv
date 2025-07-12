module TopModule(
    input  clk,
    input  d,
    output reg q
);

reg q_rising;
reg q_falling_latch;

// Rising edge flip-flop captures d on posedge clk
always @(posedge clk) begin
    q_rising <= d;
end

// Falling edge latch captures d when clk is low (transparent latch)
always @(clk or d) begin
    if (!clk)
        q_falling_latch <= d;
end

// Output q follows q_rising when clk is high and q_falling_latch when clk is low
always @(*) begin
    if (clk)
        q = q_rising;
    else
        q = q_falling_latch;
end

endmodule