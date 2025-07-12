module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state; // 1-bit register to hold the state
assign out = state; // assign output as the current state

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // asynchronous reset to state B
    end else begin
        // Implement next state logic directly based on the state diagram
        // State A (0) -> State B (1) on in=0, stay in A on in=1
        // State B (1) -> State A (0) on in=0, stay in B on in=1
        // This can be simplified to: next_state = state ^ (~in)
        state <= state ^ (~in);
    end
end

endmodule