module TopModule (
    input clock,
    input a,
    output p,
    output q
);

reg p_reg, q_reg;

// Positive edge-triggered flip-flop for p
assign p = (posedge clock) ? a : p_reg;

// Negative edge-triggered flip-flop for q
assign q = (negedge clock) ? p : q_reg;

// Store previous values
always @(posedge clock) p_reg <= p;
always @(negedge clock) q_reg <= q;

endmodule