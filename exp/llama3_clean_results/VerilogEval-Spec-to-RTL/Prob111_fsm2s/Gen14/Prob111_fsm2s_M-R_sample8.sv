module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // Single flip-flop for OFF (0) and ON (1) states

// State transition logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        case (state)
            1'b0: state <= j? 1'b1 : 1'b0; // Transition to ON if j is 1, otherwise stay in OFF
            1'b1: state <= ~k? 1'b1 : 1'b0; // Stay in ON state if k is 0, otherwise transition to OFF
        endcase
    end
end

// Output logic
always_comb begin
    case (state)
        1'b0: out = 1'b0; // Output 0 when in OFF state
        1'b1: out = 1'b1; // Output 1 when in ON state
    endcase
end

endmodule