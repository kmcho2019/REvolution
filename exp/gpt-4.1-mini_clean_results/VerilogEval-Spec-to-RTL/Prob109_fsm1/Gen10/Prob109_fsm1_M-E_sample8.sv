module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // One-hot state registers
    reg state_A;
    reg state_B;

    // Next state signals (combinational)
    wire next_state_A;
    wire next_state_B;

    // Asynchronous reset and state flip-flops update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset to state B
            state_A <= 1'b0;
            state_B <= 1'b1;
        end else begin
            state_A <= next_state_A;
            state_B <= next_state_B;
        end
    end

    // Next state logic
    assign next_state_A = (state_B & ~in) | (state_A & in);
    assign next_state_B = (state_B & in)  | (state_A & ~in);

    // Output for Moore machine (1 for B, 0 for A)
    assign out = state_B;

endmodule