module TopModule(
    input clk,
    input d,
    output q
);

reg q_rising, q_falling;
reg prev_clk;

always @(posedge clk) begin
    q_rising <= d;
end

always @(negedge clk) begin
    q_falling <= d;
end

always @(*) begin
    if (clk) begin
        q <= q_rising;
    end else begin
        q <= q_falling;
    end
end

endmodule