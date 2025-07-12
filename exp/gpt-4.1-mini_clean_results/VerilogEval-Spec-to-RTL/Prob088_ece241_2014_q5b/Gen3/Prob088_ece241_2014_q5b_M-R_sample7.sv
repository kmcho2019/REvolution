module TopModule (
    input  clk,
    input  areset,
    input  x,
    output wire z
);
    // One-hot encoded states: 
    // state_A = 1 means FSM is in state A
    // state_B = 1 means FSM is in state B
    reg state_A, state_B;

    // Next state signals
    wire next_state_A, next_state_B;

    // Next state logic (combinational)
    // From A: if x=0, stay in A; if x=1, go to B
    assign next_state_A = (state_A & ~x) | (areset); // areset forces A
    assign next_state_B = (state_A & x) | (state_B);

    // Sequential state registers with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1; // Reset to state A
            state_B <= 1'b0;
        end else begin
            state_A <= next_state_A;
            state_B <= next_state_B;
        end
    end

    // Mealy output logic: z depends on current state and input x
    // According to the FSM:
    // A -- x=0 --> z=0
    // A -- x=1 --> z=1
    // B -- x=0 --> z=1
    // B -- x=1 --> z=0
    assign z = (state_A & x) | (state_B & ~x);

endmodule