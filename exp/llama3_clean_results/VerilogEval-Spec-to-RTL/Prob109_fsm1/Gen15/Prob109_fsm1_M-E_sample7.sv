module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state; // 1-bit signal representing the current state

// Current state update
always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset
        state <= 1'b1; // Reset to state B
    end else begin
        case ({state, in})
            2'b00: state <= 1'b1; // State A, in = 0, next state = B
            2'b01: state <= 1'b0; // State A, in = 1, next state = A
            2'b10: state <= 1'b0; // State B, in = 0, next state = B
            2'b11: state <= 1'b1; // State B, in = 1, next state = B
            default: state <= 1'b1; // Default to state B
        endcase
    end
end

// Out is directly derived from the state in this implementation
assign out = state;

endmodule