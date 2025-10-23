module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg p_reg;
reg q_reg;

always @(posedge clock) begin
    if (a) begin
        p_reg <= 1'b1;
        if (p_reg) begin
            q_reg <= 1'b1;
        end
    end else begin
        p_reg <= 1'b0;
    end
end

always @(negedge clock) begin
    if (a) begin
        q_reg <= 1'b1;
    end
end

assign p = p_reg;
assign q = q_reg;

endmodule