module TopModule(
    input  clk,
    input  d,
    output q
);

reg q_rising;
reg q_falling;
reg prev_clk;

always @(posedge clk) begin
    q_rising <= d;
end

always @(negedge clk) begin
    q_falling <= d;
end

always @(posedge clk or negedge clk) begin
    prev_clk <= clk;
end

assign q = (clk == 1'b1) ? q_rising : q_falling;

endmodule