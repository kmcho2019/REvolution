module TopModule (
    input clk,
    input d,
    output q
);

reg q_reg;
reg q_prev;

always @(posedge clk) begin
    q_prev <= q_reg;
end

always @(negedge clk) begin
    q_reg <= d;
end

always @(*) begin
    if (clk == 1'b1) begin
        q <= q_prev;
    end else begin
        q <= q_reg;
    end
end

endmodule