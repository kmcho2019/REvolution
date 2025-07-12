module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg p_reg, q_reg;
reg p_next, q_next;

initial begin
    p_reg = 0;
    q_reg = 0;
end

// Next state logic for p based on a and current q_reg
always @(*) begin
    // From waveform analysis:
    // p_next is 1 when a=1 or when p_reg and q_reg are both 1 (holding state)
    // but more precisely, from waveform, p_next = a | (p_reg & q_reg)
    p_next = a | (p_reg & q_reg);
end

// Next state logic for q: q_next just latches p_reg at negedge clock
always @(*) begin
    q_next = p_reg;
end

// Sequential updates
always @(posedge clock) begin
    p_reg <= p_next;
end

always @(negedge clock) begin
    q_reg <= q_next;
end

assign p = p_reg;
assign q = q_reg;

endmodule