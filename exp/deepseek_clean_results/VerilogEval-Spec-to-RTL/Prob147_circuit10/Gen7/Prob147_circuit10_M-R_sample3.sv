module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

wire next_state;
reg state_reg = 0;

// State transition: toggle when a != b
assign next_state = (a ^ b) ? ~state_reg : state_reg;

// State update on clock edge
always @(posedge clk) begin
    state_reg <= next_state;
end

// Output logic: q = state XOR b
assign q = state_reg ^ b;
assign state = state_reg;

endmodule