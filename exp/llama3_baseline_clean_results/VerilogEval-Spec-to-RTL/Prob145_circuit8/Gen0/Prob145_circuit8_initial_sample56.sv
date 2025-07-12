module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg p_reg = 0;
reg q_reg = 0;

always @(posedge clock) begin
    p_reg <= a;
end

always @(posedge clock or negedge clock) begin
    if (clock == 1'b0 && p_reg == 1'b1) begin
        q_reg <= 1'b1;
    end else if (a == 1'b1 && p_reg == 1'b1) begin
        q_reg <= 1'b1;
    end else if (a == 1'b0 && p_reg == 1'b0 && clock == 1'b0) begin
        q_reg <= 1'b0;
    end
end

assign p = p_reg;
assign q = q_reg;

endmodule