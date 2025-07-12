module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // State register, 0 for OFF, 1 for ON

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to OFF state
    end else if (state == 0 && j) begin
        state <= 1; // Transition from OFF to ON
    end else if (state == 1 && k) begin
        state <= 0; // Transition from ON to OFF
    end
end

assign out = state; // Output determined by current state

endmodule