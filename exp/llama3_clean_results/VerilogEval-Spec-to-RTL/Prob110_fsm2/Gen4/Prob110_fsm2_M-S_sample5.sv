module TopModule(
    input        clk,    // clock
    input        areset, // asynchronous reset
    input        j,      // input j
    input        k,      // input k
    output logic out     // output
);

reg state; // current state

always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= 1'b0; // Reset to OFF state (out=0)
    end else begin
        // Simplified next-state logic
        state <= (state == 1'b0)? j : ~k;
    end
end

// Output logic directly from state
assign out = state;

endmodule