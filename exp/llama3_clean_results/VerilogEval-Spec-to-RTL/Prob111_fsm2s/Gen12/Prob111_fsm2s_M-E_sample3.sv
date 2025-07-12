module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // Current state (OFF or ON)
reg next_state; // Next state

// Lookup table (LUT) for state transitions and output generation
always_comb begin
    case (state)
        1'b0: begin // OFF state
            if (j) begin
                next_state = 1'b1; // Transition to ON state when j is high
                out = 1'b0; // Output is 0 in OFF state
            end else begin
                next_state = 1'b0; // Stay in OFF state when j is low
                out = 1'b0; // Output is 0 in OFF state
            end
        end
        1'b1: begin // ON state
            if (k) begin
                next_state = 1'b0; // Transition to OFF state when k is high
                out = 1'b1; // Output is 1 in ON state
            end else begin
                next_state = 1'b1; // Stay in ON state when k is low
                out = 1'b1; // Output is 1 in ON state
            end
        end
    endcase
end

// State register with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        state <= next_state; // Update state
    end
end

endmodule