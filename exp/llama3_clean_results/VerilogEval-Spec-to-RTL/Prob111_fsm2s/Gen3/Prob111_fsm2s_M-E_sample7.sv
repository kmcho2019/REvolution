module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state;

// Next state logic based on current state and inputs
always @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else if (state == 1'b0 && j == 1'b1) begin
        state <= 1'b1; // Transition to ON state if j is high
    end else if (state == 1'b1 && k == 1'b1) begin
        state <= 1'b0; // Transition to OFF state if k is high
    end else begin
        state <= state; // Stay in the same state
    end
end

// Output logic based on current state
assign out = state;

endmodule