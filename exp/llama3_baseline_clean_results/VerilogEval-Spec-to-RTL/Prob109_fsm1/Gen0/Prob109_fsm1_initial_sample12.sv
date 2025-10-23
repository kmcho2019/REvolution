module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

reg state; // 1-bit signal to represent the current state (B=1, A=0)

always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset to state B
        state <= 1'b1;
    end else begin
        case (state)
            1'b1: // State B
                if (~in) begin // Transition to A on in=0
                    state <= 1'b0;
                end else begin // Stay in B on in=1
                    state <= 1'b1;
                end
            1'b0: // State A
                state <= 1'b1; // Always transition back to B
            default: state <= 1'b1; // Default to B for any other state value
        endcase
    end
end

always @(*) begin
    case (state)
        1'b1: out = 1'b1; // Output is 1 when in state B
        1'b0: out = 1'b0; // Output is 0 when in state A
        default: out = 1'b1; // Default output to 1 for any other state value
    endcase
end

endmodule