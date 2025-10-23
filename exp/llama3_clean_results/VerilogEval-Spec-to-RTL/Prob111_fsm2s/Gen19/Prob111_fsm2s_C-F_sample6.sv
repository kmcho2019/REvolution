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
    end else begin
        case (state)
            1'b0: state <= j; // Transition to ON if j is 1, otherwise stay in OFF
            1'b1: state <= ~k; // Stay in ON state if k is 0, otherwise transition to OFF
        endcase
    end
end

assign out = state; // Output is the same as the current state

endmodule