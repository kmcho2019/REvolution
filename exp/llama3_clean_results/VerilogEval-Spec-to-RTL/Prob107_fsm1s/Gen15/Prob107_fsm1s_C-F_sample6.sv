module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define states using parameters
parameter STATE_B = 1'b0;
parameter STATE_A = 1'b1;

reg state; // State variable

// Direct output assignment based on the state
assign out = ~state;

always @(posedge clk) begin
    if(reset) begin
        // Reset to state B when reset is high
        state <= STATE_B;
    end else begin
        // Simplified state transition logic
        case(state)
            STATE_B: state <= in? STATE_B : STATE_A;
            STATE_A: state <= in? STATE_A : STATE_B;
            default: state <= STATE_B; // Default state
        endcase
    end
end

endmodule