module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

reg [1:0] state; // Using 2 bits to represent the states, with B as 1 and A as 0

always @(*) begin
    if (areset) begin
        state = 1; // Reset to state B
    end else begin
        case (state)
            1: begin // State B
                if (in) begin
                    state = 1; // Stay in B
                end else begin
                    state = 0; // Move to A
                end
            end
            0: begin // State A
                if (in) begin
                    state = 0; // Stay in A
                end else begin
                    state = 1; // Move to B
                end
            end
            default: state = 1; // Invalid state, reset to B
        endcase
    end
end

always @(posedge clk) begin
    // Determine output based on the current state
    case (state)
        1: out = 1; // Output for state B
        0: out = 0; // Output for state A
        default: out = 1; // Default output for invalid state
    endcase
end

endmodule