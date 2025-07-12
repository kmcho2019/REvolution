module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg p_reg = 0;
reg q_reg = 0;

always @(posedge clock) begin
    if (a) begin
        p_reg <= 1;
    end else begin
        p_reg <= 0;
    end
end

always @(posedge clock or negedge clock) begin
    if (clock) begin
        if (a) begin
            q_reg <= q_reg;
        end else begin
            q_reg <= q_reg;
        end
    end else begin
        if (a) begin
            q_reg <= 1;
        end else begin
            q_reg <= q_reg;
        end
    end
end

assign p = p_reg;
assign q = q_reg;

endmodule