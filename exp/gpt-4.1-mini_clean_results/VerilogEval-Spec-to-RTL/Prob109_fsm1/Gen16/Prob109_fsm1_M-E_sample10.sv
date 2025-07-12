module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // One-hot state encoding
    reg state_A, state_B;

    // Asynchronous reset and synchronous state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b0;
            state_B <= 1'b1;  // Reset to B
        end else begin
            // Next state logic:
            // From state B: on input=0 go to A, on input=1 stay in B
            // From state A: on input=0 go to B, on input=1 stay in A
            state_A <= (state_B & ~in) | (state_A & in);
            state_B <= (state_B & in)  | (state_A & ~in);
        end
    end

    // Output is '1' in state B and '0' in state A
    assign out = state_B;

endmodule