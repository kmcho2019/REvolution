module TopModule (
    input  clk,
    input  d,
    output q
);

reg q_rising, q_falling;
reg prev_clk;

always @(posedge clk) begin
    q_rising <= d;
    prev_clk <= 1'b1;
end

always @(negedge clk) begin
    q_falling <= d;
    prev_clk <= 1'b0;
end

assign q = (prev_clk) ? q_rising : q_falling;

endmodule