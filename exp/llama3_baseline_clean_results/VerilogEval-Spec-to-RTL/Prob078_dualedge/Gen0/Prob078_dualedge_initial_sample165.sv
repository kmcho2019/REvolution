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

always @(*) begin
    if (clk != prev_clk) begin
        if (clk) begin
            q <= q_rising;
        end else begin
            q <= q_falling;
        end
    end
    prev_clk <= clk;
end

endmodule