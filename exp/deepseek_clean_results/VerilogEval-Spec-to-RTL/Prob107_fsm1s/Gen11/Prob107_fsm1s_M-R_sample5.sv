module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding (wire instead of reg)
    wire state;
    reg state_reg;

    // Continuous state transition logic
    assign state = reset ? 1'b0 :  // STATE_B on reset
                  (state_reg == 1'b0) ? (in ? 1'b0 : 1'b1) :  // STATE_B transitions
                  (in ? 1'b1 : 1'b0);  // STATE_A transitions

    // Synchronous state update
    always @(posedge clk) begin
        state_reg <= state;
    end

    // Output logic (same as original)
    assign out = ~state_reg;

endmodule