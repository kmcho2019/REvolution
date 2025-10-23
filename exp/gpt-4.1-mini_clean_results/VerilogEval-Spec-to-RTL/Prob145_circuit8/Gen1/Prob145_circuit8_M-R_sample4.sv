module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg p_reg, q_reg;
reg p_next;

// Combinational logic for next p value
always @(*) begin
    if (q_reg == 1'b0)
        p_next = a;
    else
        p_next = a ? 1'b1 : 1'b0;
end

// Sequential logic to update p and q on posedge clock
always @(posedge clock) begin
    p_reg <= p_next;
    q_reg <= p_reg;
end

// Outputs driven from registers
assign p = p_reg;
assign q = q_reg;

initial begin
    p_reg = 1'b0;
    q_reg = 1'b0;
end

endmodule