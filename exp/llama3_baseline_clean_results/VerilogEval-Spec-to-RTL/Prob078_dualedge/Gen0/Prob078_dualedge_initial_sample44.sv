module TopModule(
    input  clk,
    input  d,
    output q
);

reg q_reg;
reg q_pos;
reg q_neg;

always @(posedge clk) begin
    q_pos <= d;
end

always @(negedge clk) begin
    q_neg <= d;
end

always @(posedge clk or negedge clk) begin
    if (q_pos != q_neg) begin
        q_reg <= q_pos;
    end else begin
        q_reg <= q_reg;
    end
end

assign q = q_reg;

endmodule