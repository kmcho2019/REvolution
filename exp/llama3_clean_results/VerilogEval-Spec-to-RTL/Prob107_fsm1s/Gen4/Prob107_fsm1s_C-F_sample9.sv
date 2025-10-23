module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Parameterized state type
parameter STATE_B = 1'b1, STATE_A = 1'b0;
reg state; // 1-bit variable to hold the state

// Sequential logic for state transitions
always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= STATE_B; // Reset to state B
    end else begin
        case(state)
            STATE_A: state <= (in == 1'b0)? STATE_B : STATE_A; // From A, in=0 -> B, in=1 -> A
            STATE_B: state <= (in == 1'b0)? STATE_A : STATE_B; // From B, in=0 -> A, in=1 -> B
        endcase
    end
end

// Directly assign the output based on the current state
always @(*) begin
    case(state)
        STATE_A: out = 1'b0; // State A, out = 0
        STATE_B: out = 1'b1; // State B, out = 1
    endcase
end

endmodule