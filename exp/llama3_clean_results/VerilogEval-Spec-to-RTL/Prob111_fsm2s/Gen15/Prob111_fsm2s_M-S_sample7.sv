module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // Current state (OFF or ON)

// State register with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else if (state == 1'b0 && j) begin
        state <= 1'b1; // Transition to ON state when j is high
    end else if (state == 1'b1 && k) begin
        state <= 1'b0; // Transition to OFF state when k is high
    end
end

// Output generation
always_comb begin
    out = state; // Output is 1 in ON state and 0 in OFF state
end

endmodule