module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // 0: OFF, 1: ON

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to OFF state
    end else begin
        case (state)
            0: state <= j ? 1 : 0; // From OFF state, transition to ON if j=1
            1: state <= k ? 0 : 1; // From ON state, transition to OFF if k=1
        endcase
    end
end

assign out = state; // Output is the current state

endmodule