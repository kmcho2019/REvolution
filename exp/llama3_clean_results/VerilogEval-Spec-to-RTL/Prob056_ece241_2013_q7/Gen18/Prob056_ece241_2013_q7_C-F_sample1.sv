module TopModule(
    input clk,
    input j,
    input k,
    output reg Q = 0 // Initialize Q to 0 for predictable behavior
);

// Combinational logic to determine the next state
reg next_Q;
always @(*) begin
    next_Q = (j == 1'b0 && k == 1'b0) ? Q : // No change
             (j == 1'b0 && k == 1'b1) ? 1'b0 : // Reset
             (j == 1'b1 && k == 1'b0) ? 1'b1 : // Set
             (j == 1'b1 && k == 1'b1) ? ~Q : Q; // Toggle
end

// Sequential logic to update the state at the positive clock edge
always @(posedge clk) begin
    Q <= next_Q; // Non-blocking assignment to avoid race conditions
end

endmodule