module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // Single-bit state register (OFF=0, ON=1)

// State register with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else if (state == 1'b0) begin
        state <= j; // Transition from OFF to ON based on j
    end else begin
        state <= ~k; // Stay in ON if k=0, transition to OFF if k=1
    end
end

// Output logic (direct assignment)
assign out = state;

endmodule