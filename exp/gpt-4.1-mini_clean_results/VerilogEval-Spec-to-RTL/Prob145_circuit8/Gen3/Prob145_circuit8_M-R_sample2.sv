module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg p_reg, q_reg;
wire p_next, q_next;

// Next state logic
assign q_next = p_reg;                 // q gets previous p
assign p_next = a | (p_reg & q_reg);  // p updates based on a and previous states

// Sequential state update
always @(posedge clock) begin
    p_reg <= p_next;
    q_reg <= q_next;
end

// Outputs driven by state registers
assign p = p_reg;
assign q = q_reg;

// Initialize registers to zero to remove initial 'x'
initial begin
    p_reg = 1'b0;
    q_reg = 1'b0;
end

endmodule