module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

// State register, 0 for OFF, 1 for ON
reg state;

always @(posedge clk) begin
    if (reset) begin
        // Reset to OFF state
        state <= 1'b0;
    end else if (state == 1'b0) begin // Currently in OFF state
        // Transition to ON if j is 1
        state <= j;
    end else begin // Currently in ON state
        // Stay in ON if k is 0, else transition to OFF
        state <= ~k;
    end
end

// Output is the same as the current state
assign out = state;

endmodule