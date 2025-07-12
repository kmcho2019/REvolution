module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // One-hot encoded state bits
    reg state_A, state_B;

    // Next state signals
    wire next_A, next_B;

    // Asynchronous active-high reset for state bits
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;  // reset to state A
            state_B <= 1'b0;
        end else begin
            state_A <= next_A;
            state_B <= next_B;
        end
    end

    // Next state logic:
    // From state A: if x=0 -> stay in A; if x=1 -> go to B
    // From state B: always stay in B
    assign next_A = (state_A & ~x);
    assign next_B = (state_A & x) | state_B;

    // Output logic (Mealy):
    // z = 1 when (state_A & x) or (state_B & ~x), else 0
    assign z = (state_A & x) | (state_B & ~x);

endmodule