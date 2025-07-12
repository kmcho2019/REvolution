module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // Use a 1-bit register to represent the two states (A=0, B=1)

always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset
        state <= 1'b1; // Reset into state B
    end else begin
        case (state)
            1'b0: // State A
                if (!in) begin
                    state <= 1'b1; // Transition from A to B on input 0
                end else begin
                    state <= 1'b0; // Stay in A on input 1
                end
            1'b1: // State B
                if (!in) begin
                    state <= 1'b0; // Transition from B to A on input 0
                end else begin
                    state <= 1'b1; // Stay in B on input 1
                end
            default: state <= 1'b1; // Default to state B if unexpected state value
        endcase
    end
end

// Output is determined by the state (Moore machine property)
assign out = state;

endmodule