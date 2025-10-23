module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg state; // Current state
reg next_state; // Next state

always @(*) begin
    case(state)
        1'b0: begin // State A
            if (in) next_state = 1'b0; // Stay in A if in = 1
            else next_state = 1'b1; // Go to B if in = 0
        end
        1'b1: begin // State B
            if (in) next_state = 1'b1; // Stay in B if in = 1
            else next_state = 1'b0; // Go to A if in = 0
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) state <= 1'b1; // Asynchronously reset to state B
    else state <= next_state; // Update state on clock edge
end

assign out = state; // Output is the current state

endmodule