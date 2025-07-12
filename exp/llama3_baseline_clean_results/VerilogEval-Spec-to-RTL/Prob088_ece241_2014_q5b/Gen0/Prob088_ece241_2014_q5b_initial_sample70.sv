module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state; // One-hot encoding for states A and B
reg [1:0] next_state; // Next state based on current state and input

// Output z logic based on current state and input
assign z = (state[0] && ~x) ? 1'b0 : (state[1] || (state[0] && x)) ? 1'b1 : 1'b0;

// State transition logic
always @(state, x) begin
    case(state)
        2'b01: next_state = x ? 2'b10 : 2'b01; // State A transitions
        2'b10: next_state = 2'b10; // State B remains in itself
        default: next_state = 2'b01; // Default or invalid states reset to A
    endcase
end

// Sequential logic with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        state <= next_state;
    end
end

endmodule