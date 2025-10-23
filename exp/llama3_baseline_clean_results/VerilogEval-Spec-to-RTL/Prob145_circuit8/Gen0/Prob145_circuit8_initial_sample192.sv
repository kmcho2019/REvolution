module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg p_reg;
reg q_reg;

assign p = p_reg;
assign q = q_reg;

always @(posedge clock) begin
    if (a) begin
        p_reg <= 1;
        q_reg <= 1;
    end else begin
        p_reg <= 0;
    end
end

always @(negedge clock) begin
    if (a) begin
        q_reg <= 1;
    end else if (~a && ~clock) begin
        q_reg <= q_reg;
    end
end

initial begin
    p_reg = 0;
    q_reg = 0;
end

endmodule