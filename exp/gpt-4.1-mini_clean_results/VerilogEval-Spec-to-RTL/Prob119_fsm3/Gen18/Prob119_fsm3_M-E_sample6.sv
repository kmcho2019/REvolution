module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // One-hot state encoding: each state is a separate bit
    reg state_A, state_B, state_C, state_D;
    reg next_A, next_B, next_C, next_D;

    // Asynchronous reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
            state_C <= 1'b0;
            state_D <= 1'b0;
        end else begin
            state_A <= next_A;
            state_B <= next_B;
            state_C <= next_C;
            state_D <= next_D;
        end
    end

    // Next state combinational logic based on current states and input
    // From transition table:
    // A: in=0->A, in=1->B
    // B: in=0->C, in=1->B
    // C: in=0->A, in=1->D
    // D: in=0->C, in=1->B

    always @(*) begin
        next_A = (state_A & ~in) | (state_C & ~in);
        next_B = (state_A & in) | (state_B & in) | (state_D & in);
        next_C = (state_B & ~in) | (state_D & ~in);
        next_D = (state_C & in);
    end

    // Moore output depends only on state D
    assign out = state_D;

endmodule