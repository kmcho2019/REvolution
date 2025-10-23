module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg p_reg;
reg q_reg;

always @(posedge clock or negedge clock) begin
    if (~clock) begin
        if (a) begin
            q_reg <= 1'b1;
        end else if (~a) begin
            p_reg <= 1'b0;
        end
    end else begin
        if (a) begin
            p_reg <= 1'b1;
            q_reg <= 1'b1;
        end else begin
            p_reg <= 1'b0;
        end
    end
end

assign p = p_reg;
assign q = q_reg;

endmodule