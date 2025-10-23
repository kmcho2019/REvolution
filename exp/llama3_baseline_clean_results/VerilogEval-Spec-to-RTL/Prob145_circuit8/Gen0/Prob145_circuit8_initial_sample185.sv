module TopModule(
    input  clock,
    input  a,
    output p,
    output q
);

reg p_reg;
reg q_reg;

always @(posedge clock or negedge clock) begin
    if (~clock) begin
        if (a) begin
            p_reg <= 0;
            q_reg <= 1;
        end else begin
            p_reg <= 0;
            if (q_reg) begin
                q_reg <= 1;
            end else begin
                q_reg <= 0;
            end
        end
    end else begin
        if (a) begin
            p_reg <= 1;
            q_reg <= 0;
        end else begin
            p_reg <= 0;
            q_reg <= 0;
        end
    end
end

assign p = p_reg;
assign q = q_reg;

endmodule