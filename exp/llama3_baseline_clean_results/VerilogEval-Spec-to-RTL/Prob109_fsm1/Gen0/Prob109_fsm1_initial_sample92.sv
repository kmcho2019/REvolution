module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // Using 1 bit to represent the state: 1 for B, 0 for A

// Assign output based on the current state
assign out = state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to state B
        state <= 1'b1;
    end else begin
        case (state)
            1'b1: // State B
                if (!in) begin
                    state <= 1'b0; // Move to state A
                end
            1'b0: // State A
                if (!in) begin
                    state <= 1'b1; // Move to state B
                end else begin
                    state <= 1'b0; // Stay in state A
                end
            default:
                state <= 1'b1; // Default to state B if somehow ends up in an invalid state
        endcase
    end
end

endmodule