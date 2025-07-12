module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_rising;
reg q_falling;

always @(posedge clk) begin
    q_rising <= d;
end

always @(negedge clk) begin
    q_falling <= d;
end

always @(posedge clk or negedge clk) begin
    if (clk == 1'b1) begin
        q <= q_rising;
    end else begin
        q <= q_falling;
    end
end

endmodule