module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // Single flip-flop for OFF (0) and ON (1) states

// Output logic remains the same as it directly depends on the state
assign out = state;

// State transition logic remains straightforward for simplicity and performance
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Synchronous reset to OFF state
    end else begin
        case (state)
            1'b0: state <= j; // Transition to ON if j is 1, otherwise stay in OFF
            1'b1: state <= ~k; // Stay in ON if k is 0, otherwise transition to OFF
        endcase
    end
end

endmodule