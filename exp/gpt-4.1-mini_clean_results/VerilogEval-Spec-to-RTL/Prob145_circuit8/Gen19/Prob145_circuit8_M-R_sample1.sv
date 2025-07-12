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

initial begin
    p_reg = 1'bx;
    q_reg = 1'bx;
end

// Update p_reg first based on previous q_reg and a
always @(posedge clock) begin
    if (q_reg === 1'b0)
        p_reg <= a;
    else
        p_reg <= p_reg; // hold previous value if q_reg not zero
end

// Update q_reg to previous p_reg value (delay p by one cycle)
always @(posedge clock) begin
    q_reg <= p_reg;
end

endmodule