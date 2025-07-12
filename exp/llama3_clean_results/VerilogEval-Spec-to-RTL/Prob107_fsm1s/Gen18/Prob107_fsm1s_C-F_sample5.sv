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
        out <= (RESET_STATE == STATE_B) ? 1'b1 : 1'b0; // Reset output
    end else begin
        if (~in) begin
            state <= ~state; // Update state based on input
        end else begin
            state <= state; // No change if in is 1
        end
        out <= (state == STATE_B) ? 1'b1 : 1'b0; // Update output based on new state
    end
end

endmodule