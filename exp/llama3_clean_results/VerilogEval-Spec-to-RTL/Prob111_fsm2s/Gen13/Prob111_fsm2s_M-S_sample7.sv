module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // State register for OFF (0) and ON (1) states

// Output logic
assign out = state; // Directly assign state value to output

// State register with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        case (state)
            1'b0: if (j) state <= 1'b1; // Transition from OFF to ON when j is high
            1'b1: if (k) state <= 1'b0; // Transition from ON to OFF when k is high
        endcase
    end
end

endmodule