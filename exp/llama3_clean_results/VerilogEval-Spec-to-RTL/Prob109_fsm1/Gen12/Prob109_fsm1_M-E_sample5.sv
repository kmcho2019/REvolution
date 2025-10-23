module TopModule(
    input        clk,
    input        areset,
    input        in,
    output       out
);

reg state; // Current state

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b1; // Reset to state B (1)
    end else begin
        // Next state logic based on current state and input
        if (state == 1'b0) begin // Current state is A (0)
            if (in == 1'b0) begin
                state <= 1'b1; // Transition to state B (1)
            end else begin
                state <= 1'b0; // Remain in state A (0)
            end
        end else begin // Current state is B (1)
            if (in == 1'b0) begin
                state <= 1'b0; // Transition to state A (0)
            end else begin
                state <= 1'b1; // Remain in state B (1)
            end
        end
    end
end

// Output generation based on current state
assign out = state;

endmodule