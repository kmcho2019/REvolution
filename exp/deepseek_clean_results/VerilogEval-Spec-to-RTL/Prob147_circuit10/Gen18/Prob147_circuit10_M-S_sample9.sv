module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

// Simplified next state logic
wire next_state = (a & b) | (state_reg & ~(~a & ~b));

// State register update
always @(posedge clk) begin
    state_reg <= next_state;
end

// Simplified output logic
assign q = a ^ b ^ state_reg;
assign state = state_reg;

endmodule