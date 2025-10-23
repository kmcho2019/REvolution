module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state_A, state_B; // One-hot encoding for states A and B

always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset
        state_A <= 1'b0; // Reset to state B
        state_B <= 1'b1;
    end else begin
        case ({state_A, state_B}) // Current state encoded as one-hot
            2'b01: begin // Currently in state B
                if (in) begin
                    state_A <= 1'b0;
                    state_B <= 1'b1;
                end else begin
                    state_A <= 1'b1;
                    state_B <= 1'b0;
                end
            end
            2'b10: begin // Currently in state A
                if (in) begin
                    state_A <= 1'b1;
                    state_B <= 1'b0;
                end else begin
                    state_A <= 1'b0;
                    state_B <= 1'b1;
                end
            end
            default: begin // This should not happen in a correct one-hot encoding
                state_A <= 1'b0;
                state_B <= 1'b1; // Default to state B if both or none are set
            end
        endcase
    end
end

// Out is derived from the state
assign out = state_B; // Since state B is the one that directly corresponds to the output '1'

endmodule