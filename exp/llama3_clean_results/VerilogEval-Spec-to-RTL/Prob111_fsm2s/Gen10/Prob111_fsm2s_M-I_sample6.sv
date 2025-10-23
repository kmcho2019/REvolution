module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // Single flip-flop for OFF (0) and ON (1) states

// Output logic
assign out = state; // Directly assign state to output

// State register with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        // Simplified state transition logic
        state <= (state == 1'b0) ? j : (state == 1'b1) ? !k ? 1'b1 : 1'b0 : 1'b0;
    end
end

endmodule