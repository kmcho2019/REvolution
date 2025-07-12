module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

// Optimized next state logic - fewer operations
wire next_state = (a & b) | (state_reg & (a | b));

// State register update
always @(posedge clk) begin
    state_reg <= next_state;
end

// Optimized output logic - reduced switching
assign q = state_reg ? ~(a ^ b) : (a ^ b);
assign state = state_reg;

endmodule