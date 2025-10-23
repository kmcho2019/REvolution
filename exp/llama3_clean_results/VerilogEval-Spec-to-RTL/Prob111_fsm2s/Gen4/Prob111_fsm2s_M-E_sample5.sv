module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state;

// Output logic based on current state
assign out = state;

// State register with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        state <= (state && !k) || (!state && j); // Directly encode state transitions
    end
end

endmodule