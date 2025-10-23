module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg state; // One-hot encoding for state A (1'b0) and state B (1'b1)

// Directly derive output 'z' using assign statement
assign z = (state) ? ~x : x;

// Sequential logic for state transition
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
    end else begin
        // Simplified next state logic based on current state and input 'x'
        if (!state && x) begin
            state <= 1'b1; // Transition to state B
        end else if (state) begin
            // Stay in state B regardless of 'x'
        end
    end
end

endmodule