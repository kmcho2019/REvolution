module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

parameter STATE_B = 0, STATE_A = 1; // Parameterized state encoding
parameter RESET_STATE = STATE_B; // Parameterized reset state

reg state; // Current state

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= RESET_STATE; // Reset to the defined reset state
        out <= 1'b1; // Reset output to 1 for state B
    end else begin
        case(state)
            STATE_B: 
                if (!in) begin
                    state <= STATE_A;
                    out <= 1'b0;
                end
            STATE_A: 
                if (in) begin
                    // No need to change state or output
                end else begin
                    state <= STATE_B;
                    out <= 1'b1;
                end
            default: 
                state <= RESET_STATE; // Default to reset state
                out <= 1'b1; // Default output to 1 for state B
        endcase
    end
end

endmodule