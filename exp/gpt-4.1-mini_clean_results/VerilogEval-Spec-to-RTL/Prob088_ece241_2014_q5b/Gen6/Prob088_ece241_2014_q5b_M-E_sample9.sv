module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);
    // One-hot encoded states: 
    // state_A = 1'b1 means in state A; state_B = 1'b1 means in state B
    reg state_A, state_B;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1; // Reset to state A
            state_B <= 1'b0;
        end else begin
            // Next state logic
            // From state A: if x=1 go to B; else stay in A
            // From state B: stay in B
            state_A <= state_A & (~x); // A stays if x=0
            state_B <= state_B | (state_A & x); // B stays or transition from A on x=1
        end
    end

    // Mealy output: z depends on current state and input x
    always @(*) begin
        if (state_A)
            z = x;       // in A: z = x
        else
            z = ~x;      // in B: z = ~x
    end
endmodule