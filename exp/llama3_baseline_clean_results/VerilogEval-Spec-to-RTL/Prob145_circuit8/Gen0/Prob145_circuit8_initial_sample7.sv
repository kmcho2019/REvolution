module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg p_reg;
reg q_reg;

assign p = (clock == 1) ? a : 0;

always @(posedge clock or negedge clock) begin
    if (clock == 0) begin
        if (a == 1) begin
            q_reg <= 1;
        end else if (q_reg == 1 && a == 0) begin
            q_reg <= 0;
        end
    end else begin
        if (a == 1) begin
            q_reg <= 1;
        end else begin
            q_reg <= q_reg;
        end
    end
end

assign q = q_reg;

endmodule