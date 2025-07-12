module TopModule(
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
        case (state)
            1'b0: state <= j; // Transition from OFF based on j
            1'b1: state <= ~k; // Transition from ON based on k
            default: state <= 1'b0; // Default to OFF for invalid states
        endcase
    end
end

endmodule