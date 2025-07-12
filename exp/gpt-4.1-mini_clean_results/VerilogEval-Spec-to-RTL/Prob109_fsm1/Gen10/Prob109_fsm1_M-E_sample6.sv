module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // One-hot state encoding
    // state_A = 1 when in state A, else 0
    // state_B = 1 when in state B, else 0
    reg state_A, state_B;

    // Next state logic signals
    wire next_A, next_B;

    // State transition logic
    // From the diagram:
    // B (1) --0--> A
    // B (1) --1--> B
    // A (0) --0--> B
    // A (0) --1--> A
    //
    // Encoding:
    // next_A = (state_B & ~in) | (state_A & in)
    // next_B = (state_B & in)  | (state_A & ~in)

    assign next_A = (state_B & ~in) | (state_A & in);
    assign next_B = (state_B & in)  | (state_A & ~in);

    // State flip-flops with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b0;
            state_B <= 1'b1;  // reset to state B
        end else begin
            state_A <= next_A;
            state_B <= next_B;
        end
    end

    // Moore output is '1' in state B, '0' in state A
    // Output can be assigned directly from state_B flip-flop
    assign out = state_B;

endmodule