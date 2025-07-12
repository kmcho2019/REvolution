module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_rising, q_falling;

always @(posedge clk) begin
    q_rising <= d;
end

always @(negedge clk) begin
    q_falling <= d;
end

always @(*) begin
    // When clk is high, output q_rising; when low, output q_falling
    q = clk ? q_rising : q_falling;
end

endmodule