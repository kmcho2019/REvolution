module TopModule (
    input clock,
    input a,
    output p,
    output q
);

reg p_reg, q_reg;

// p logic: set on positive edge when a is high, clear on next edge
always @(posedge clock) begin
    p_reg <= a;
end

// q logic: follows p with one cycle delay
always @(posedge clock) begin
    q_reg <= p_reg;
end

assign p = p_reg;
assign q = q_reg;

endmodule