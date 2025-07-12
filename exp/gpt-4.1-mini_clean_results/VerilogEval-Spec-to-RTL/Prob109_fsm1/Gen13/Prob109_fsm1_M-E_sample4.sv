module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    reg state_A;
    reg state_B;

    // Next state signals
    wire next_A;
    wire next_B;

    // Asynchronous reset: set state_B = 1, state_A = 0 (state B)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b0;
            state_B <= 1'b1;
        end else begin
            state_A <= next_A;
            state_B <= next_B;
        end
    end

    // Next state logic
    // From B (state_B=1), if input=0 -> A, else remain B
    // From A (state_A=1), if input=0 -> B, else remain A
    assign next_A = (state_B & ~in) | (state_A & in);
    assign next_B = (state_B & in)  | (state_A & ~in);

    // Output is 1 when in state B
    assign out = state_B;

endmodule