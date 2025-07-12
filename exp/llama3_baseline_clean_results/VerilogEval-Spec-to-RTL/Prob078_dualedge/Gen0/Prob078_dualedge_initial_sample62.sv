module TopModule(
    input  clk,
    input  d,
    output q
);

reg q_rising, q_falling, prev_clk;

always @(posedge clk) begin
    q_rising <= d;
    prev_clk <= 1'b1;
end

always @(negedge clk) begin
    q_falling <= d;
    prev_clk <= 1'b0;
end

always @(q_rising or q_falling or prev_clk) begin
    if (prev_clk == 1'b1) begin
        q <= q_rising;
    end else if (prev_clk == 1'b0) begin
        q <= q_falling;
    end
end

endmodule