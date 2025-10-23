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
    end else begin
        case(state)
            STATE_B: state <= (in == 0) ? STATE_A : STATE_B;
            STATE_A: state <= (in == 0) ? STATE_B : STATE_A;
            default: state <= RESET_STATE; // Default to reset state
        endcase
    end
end

assign out = (state == STATE_B) ? 1'b1 : 1'b0; // Output logic based on state

endmodule