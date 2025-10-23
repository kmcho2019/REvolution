module TopModule(
    input  clock,
    input  a,
    output p,
    output q
);

reg q_reg;
reg p_reg;

initial begin
    q_reg = 0;
    p_reg = 0;
end

always @(posedge clock) begin
    if (a) begin
        p_reg <= 1;
    end else begin
        p_reg <= 0;
    end
end

always @(negedge clock) begin
    if (a) begin
        q_reg <= 1;
    end else if (~clock) begin
        q_reg <= 0;
    end
end

assign p = p_reg;
assign q = q_reg;

endmodule