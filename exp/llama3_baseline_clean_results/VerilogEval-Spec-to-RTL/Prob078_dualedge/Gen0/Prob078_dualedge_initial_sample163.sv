module TopModule(
    input  clk,
    input  d,
    output q
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

always @(posedge clk or negedge clk) begin
    if (clk == clk_prev) begin
        q <= (clk == 1'b1)? q_pos : q_neg;
    end else begin
        q <= d;
    end
end

endmodule