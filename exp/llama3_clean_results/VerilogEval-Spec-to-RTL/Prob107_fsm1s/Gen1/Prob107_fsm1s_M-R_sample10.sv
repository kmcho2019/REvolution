module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define parameters for the states
parameter STATE_A = 1'b0;
parameter STATE_B = 1'b1;

reg state; // 1-bit variable to hold the state (A=0, B=1)

// Directly assign the output based on the current state
assign out = (state == STATE_B)? 1'b1 : 1'b0;

// Sequential logic for state transitions
always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= STATE_B; // Reset to state B
    end else begin
        case(state)
            STATE_A: state <= (in == 1'b0)? STATE_B : STATE_A;
            STATE_B: state <= (in == 1'b0)? STATE_A : STATE_B;
            default: state <= 1'bx; // Should not occur
        endcase
    end
end

endmodule