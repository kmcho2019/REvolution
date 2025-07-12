module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // We only need 1 bit for two states, but using reg[0:0] for simplicity and clarity

// Asynchronous reset to state B (1)
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b1; // State B
    end else begin
        case(state)
            1'b1: // State B
                if(in == 1'b0) begin
                    state <= 1'b0; // Transition to State A
                end else begin
                    state <= 1'b1; // Stay in State B
                end
            1'b0: // State A
                if(in == 1'b0) begin
                    state <= 1'b1; // Transition to State B
                end else begin
                    state <= 1'b0; // Stay in State A
                end
            default: state <= 1'b1; // Default to State B if unexpected state
        endcase
    end
end

// Output logic
assign out = state; // out is 1 in state B and 0 in state A

endmodule