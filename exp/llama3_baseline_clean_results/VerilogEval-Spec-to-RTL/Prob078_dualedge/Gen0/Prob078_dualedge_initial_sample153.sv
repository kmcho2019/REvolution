module TopModule(
    input  clk,
    input  d,
    output q
);

reg q_rising;
reg q_falling;

always @(posedge clk) begin
    q_rising <= d;
end

always @(negedge clk) begin
    q_falling <= d;
end

assign q = clk ? q_rising : q_falling;

endmodule