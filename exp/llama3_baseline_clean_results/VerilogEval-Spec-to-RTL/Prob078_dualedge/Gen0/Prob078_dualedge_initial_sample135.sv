module TopModule(
    input  clk,
    input  d,
    output reg q
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

always @(*) begin
    if (prev_clk == 1'b1) begin
        q <= q_rising;
    end else begin
        q <= q_falling;
    end
end

endmodule