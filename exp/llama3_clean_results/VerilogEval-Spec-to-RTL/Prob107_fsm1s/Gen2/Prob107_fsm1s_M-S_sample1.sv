module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg state; // 1-bit variable to hold the state (A=0, B=1)

// Directly assign the output based on the current state
assign out = ~state; // Since out = 1 when state is B (1), and out = 0 when state is A (0)

// Sequential logic for state transitions
always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1'b1; // Reset to state B
    end else begin
        state <= (state == 1'b0 && in == 1'b0) ? 1'b1 : 
                 (state == 1'b0 && in == 1'b1) ? 1'b0 : 
                 (state == 1'b1 && in == 1'b0) ? 1'b0 : 1'b1;
    end
end

endmodule