module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 1-bit variable to hold the state (0 or 1)

// Sequential logic for state transitions
always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1'b1; // Reset to state B
    end else begin
        if (state == 1'b1) begin // Current state is B
            state <= in? 1'b1 : 1'b0; // Stay in B if in=1, go to A if in=0
        end else begin // Current state is A
            state <= in? 1'b0 : 1'b1; // Stay in A if in=1, go to B if in=0
        end
    end
end

// Combinational logic for output
always @(*) begin
    out = state; // Output is 1 in state B and 0 in state A
end

endmodule