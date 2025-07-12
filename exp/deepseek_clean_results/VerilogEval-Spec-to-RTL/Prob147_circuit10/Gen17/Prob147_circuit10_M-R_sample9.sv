module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

// Combinational next state logic
wire next_state;
assign next_state = (a & b) ? 1'b1 :  // Set when both inputs high
                   (~a & ~b) ? 1'b0 : // Reset when both inputs low
                   state_reg;          // Otherwise hold

// State register update
always @(posedge clk) begin
    state_reg <= next_state;
end

// Output logic
assign q = state_reg ? ~(a ^ b) : (a ^ b);  // XNOR when state=1, XOR when state=0
assign state = state_reg;

endmodule