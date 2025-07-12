module TopModule(
    input clock,
    input a,
    output p,
    output q
    );

reg p_reg;  // internal register for p
reg q_reg;  // internal register for q

// initialize p_reg and q_reg to 0
initial begin
    p_reg = 0;
    q_reg = 0;
end

// on every positive edge of the clock
always @(posedge clock) begin
    p_reg <= a;  // assign 'a' to p_reg
    q_reg <= p_reg;  // assign previous state of p to q_reg
end

// assign p_reg and q_reg to output p and q
assign p = p_reg;
assign q = q_reg;

endmodule