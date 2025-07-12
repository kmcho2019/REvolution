module TopModule(
    input       clk,
    input       areset,
    input       j,
    input       k,
    output      out
);

reg     state;
reg     next_state;

// Combinational logic for next state
always @(*) begin
    case(state)
        1'b0: next_state = j ? 1'b1 : 1'b0; // In OFF state, go to ON if j=1
        1'b1: next_state = k ? 1'b0 : 1'b1; // In ON state, go to OFF if k=1
    endcase
end

// Sequential logic for state register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to OFF state on asynchronous reset
    end else begin
        state <= next_state; // Update state on clock edge
    end
end

// Output logic (directly tied to the state in a Moore machine)
assign out = state;

endmodule