module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // Single flip-flop for OFF (0) and ON (1) states

assign out = state;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Synchronous reset to OFF state
    end else if (~state && j) begin
        state <= 1'b1; // Transition to ON if in OFF state and j is 1
    end else if (state && k) begin
        state <= 1'b0; // Transition to OFF if in ON state and k is 1
    end // Otherwise, stay in the current state
end

endmodule