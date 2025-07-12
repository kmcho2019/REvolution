module TopModule(
    input        clk,    // clock
    input        areset, // asynchronous reset
    input        j,      // input j
    input        k,      // input k
    output logic out     // output
);

logic state; // current state

always_latch begin
    if (areset) begin
        state = 1'b0; // Reset state to OFF
        out = 1'b0;   // Reset output to 0
    end else if (j && !state) begin
        state = 1'b1; // Transition to ON state if j=1 and currently in OFF state
        out = 1'b1;   // Set output to 1
    end else if (k && state) begin
        state = 1'b0; // Transition to OFF state if k=1 and currently in ON state
        out = 1'b0;   // Set output to 0
    end
end

endmodule