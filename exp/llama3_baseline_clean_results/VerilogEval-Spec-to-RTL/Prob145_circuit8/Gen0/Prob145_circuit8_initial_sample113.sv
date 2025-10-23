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
    end else begin
        p_reg <= 0;
    end
end

always @(posedge clock) begin
    if (p_reg && a) begin
        q_reg <= 1;
    end else begin
        q_reg <= 0;
    end
end

always @(negedge clock) begin
    if (~a) begin
        p_reg <= 0;
        q_reg <= 0;
    end
end

endmodule