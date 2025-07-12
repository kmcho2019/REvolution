module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // State register, 0 for OFF, 1 for ON

always @(posedge clk) begin
    if (reset) state <= 0; // Reset to OFF state
    else state <= (state && !k) || (!state && j); // Transition logic
end

assign out = state; // Output is directly the current state

endmodule