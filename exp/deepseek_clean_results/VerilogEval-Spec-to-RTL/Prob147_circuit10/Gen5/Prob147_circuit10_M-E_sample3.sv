module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;

// Next state logic: toggle when a and b differ
wire state_toggle = a ^ b;
wire next_state = state_toggle ? ~state_reg : state_reg;

// Output logic depends on current state
assign q = state_reg ? (a | b) : (a & b);

always @(posedge clk) begin
    state_reg <= next_state;
end

assign state = state_reg;

endmodule