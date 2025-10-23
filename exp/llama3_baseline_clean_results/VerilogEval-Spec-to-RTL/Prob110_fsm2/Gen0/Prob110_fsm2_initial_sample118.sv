module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg state; // Current state: 0 - OFF, 1 - ON
reg next_state; // Next state

// Combinational logic for next state
always @(*) begin
    case(state)
        0: next_state = (j) ? 1 : 0; // OFF state
        1: next_state = (k) ? 0 : 1; // ON state
    endcase
end

// Sequential logic for state transition
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Asynchronous reset to OFF state
    end else begin
        state <= next_state;
    end
end

// Output logic
assign out = state; // out is a function of the current state

endmodule