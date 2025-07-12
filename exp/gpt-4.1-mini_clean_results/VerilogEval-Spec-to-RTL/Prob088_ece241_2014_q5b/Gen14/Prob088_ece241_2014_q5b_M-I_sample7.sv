module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // Single flip-flop representing state A (1) or B (0)
    reg state_A;

    // Next state logic:
    // From A (state_A=1): next state is A if x=0, else B (state_A=0)
    // From B (state_A=0): always remain in B (state_A=0)
    wire next_state_A = state_A & ~x;

    // Sequential logic with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1; // reset to state A
        end else begin
            state_A <= next_state_A;
        end
    end

    // Output logic (Mealy)
    // z = x when in A (state_A=1), z = ~x when in B (state_A=0)
    assign z = state_A ? x : ~x;

endmodule