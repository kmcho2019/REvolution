module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_pos, q_neg, clk_neg;

always @(posedge clk) begin
    q_pos <= d;
end

always @(posedge clk_neg) begin
    q_neg <= d;
end

assign clk_neg = ~clk;

always @(posedge clk or negedge clk) begin
    if (clk) begin
        q <= q_pos;
    end else begin
        q <= q_neg;
    end
end

endmodule