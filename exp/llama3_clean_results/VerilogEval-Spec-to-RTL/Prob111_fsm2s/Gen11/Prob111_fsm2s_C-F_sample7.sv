module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // Single flip-flop for OFF (0) and ON (1) states

// Output logic
assign out = state;

// State transition logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        case (state)
            1'b0: state <= j; // Transition from OFF to ON if j is 1
            1'b1: state <= ~k; // Stay in ON state if k is 0, otherwise transition to OFF
            default: state <= 1'b0; // Default case for sanity
        endcase
    end
end

endmodule