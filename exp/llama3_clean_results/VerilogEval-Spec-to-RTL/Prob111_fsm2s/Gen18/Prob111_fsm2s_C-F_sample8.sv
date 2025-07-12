module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output logic out
);

logic state; // State register, 0 for OFF, 1 for ON

always_ff @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to OFF state
    end else if (state == 0) begin // Currently in OFF state
        state <= j; // Transition to ON if j is 1
    end else begin // Currently in ON state
        state <= ~k; // Stay in ON if k is 0, else transition to OFF
    end
end

assign out = state; // Output is the same as the current state

endmodule