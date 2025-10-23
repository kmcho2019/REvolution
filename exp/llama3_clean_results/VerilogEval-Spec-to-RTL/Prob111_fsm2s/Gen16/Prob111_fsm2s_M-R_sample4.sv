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
        out <= 0; // Reset output to 0
    end else begin
        case (state)
            0: begin
                state <= j ? 1 : 0; // From OFF state, transition to ON if j=1
                out <= 0; // Output remains 0 in OFF state
            end
            1: begin
                state <= k ? 0 : 1; // From ON state, transition to OFF if k=1
                out <= 1; // Output is 1 in ON state
            end
        endcase
    end
end

endmodule