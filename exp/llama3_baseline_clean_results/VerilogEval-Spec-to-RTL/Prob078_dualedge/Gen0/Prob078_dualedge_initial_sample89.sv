module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_pos, q_neg;
reg clk_prev;

always @(posedge clk) begin
    q_pos <= d;
    clk_prev <= 1'b1;
end

always @(negedge clk) begin
    q_neg <= d;
    clk_prev <= 1'b0;
end

always @(*) begin
    if (clk_prev == 1'b1) begin
        q <= q_pos;
    end else begin
        q <= q_neg;
    end
end

endmodule