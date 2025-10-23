module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 1-bit variable to hold the state (A=0, B=1)

// Directly assign output based on state
assign out = state;

// State transition logic
always @(posedge clk) begin
    if(reset) begin
        state <= 1'b1; // Reset to state B
    end else begin
        case(state)
            1'b0: // State A
                state <= in? 1'b0 : 1'b1; // Stay in A if in=1, go to B if in=0
            1'b1: // State B
                state <= in? 1'b1 : 1'b0; // Stay in B if in=1, go to A if in=0
            default: state <= 1'bx; // Invalid state, should not occur
        endcase
    end
end

endmodule