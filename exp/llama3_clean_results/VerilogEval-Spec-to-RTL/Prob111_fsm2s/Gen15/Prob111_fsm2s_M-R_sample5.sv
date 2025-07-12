module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // Current state (OFF or ON)

// Define output out based on current state
assign out = state;

// State register with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        case (state)
            1'b0: state <= j? 1'b1 : 1'b0; // Transition to ON state when j is high
            1'b1: state <= k? 1'b0 : 1'b1; // Transition to OFF state when k is high
        endcase
    end
end

endmodule