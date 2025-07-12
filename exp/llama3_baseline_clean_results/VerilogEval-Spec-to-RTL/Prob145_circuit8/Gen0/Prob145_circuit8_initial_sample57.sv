module TopModule (
    input clock,
    input a,
    output p,
    output q
);

reg p_reg;
reg q_reg;

always @(posedge clock or negedge clock) begin
    if (~clock) begin
        if (~a) begin
            p_reg <= 0;
            q_reg <= 0;
        end else begin
            p_reg <= 0;
            q_reg <= q_reg;
        end
    end else begin
        if (a) begin
            p_reg <= 1;
            if (q_reg) begin
                q_reg <= 1;
            end else if (p_reg) begin
                q_reg <= 0;
            end else begin
                q_reg <= 0;
            end
        end else begin
            p_reg <= 0;
            q_reg <= q_reg;
        end
    end
end

assign p = p_reg;
assign q = q_reg;

endmodule