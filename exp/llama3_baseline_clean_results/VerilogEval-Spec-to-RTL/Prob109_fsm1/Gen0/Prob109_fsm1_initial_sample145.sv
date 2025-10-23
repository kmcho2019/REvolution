module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state; // Register to hold the current state
always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset to state B
        state <= 1'b1; // State B
    end else begin
        case(state)
            1'b1: // State B
                if (~in) state <= 1'b0; // Transition to A if in is 0
                else    state <= 1'b1; // Stay in B if in is 1
            1'b0: // State A
                if (~in) state <= 1'b1; // Transition to B if in is 0
                else    state <= 1'b0; // Stay in A if in is 1
            default: state <= 1'b1; // Default to state B
        endcase
    end
end

assign out = state; // Output 'out' is the current state

endmodule