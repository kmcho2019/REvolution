module TopModule(
    input        clk,    // clock
    input        areset, // asynchronous reset
    input        j,      // input j
    input        k,      // input k
    output logic out     // output
);

reg state; // current state

// Asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= 1'b0; // Reset to OFF state (out=0)
    end else begin
        // Synchronous next-state logic
        if (state == 1'b0) begin // Currently in OFF state
            if (j) begin
                state <= 1'b1; // Transition to ON state if j=1
            end
        end else begin // Currently in ON state
            if (k) begin
                state <= 1'b0; // Transition to OFF state if k=1
            end
        end
    end
end

// Output logic directly from state
assign out = state;

endmodule