module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // One-hot encoding: state_A = 1 means state A, state_B = 1 means state B
    reg state_A, state_B;
    reg next_state_A, next_state_B;

    // Asynchronous reset and state register update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1; // Reset to state A
            state_B <= 1'b0;
        end else begin
            state_A <= next_state_A;
            state_B <= next_state_B;
        end
    end

    // Next state combinational logic using one-hot encoding
    // State A transitions: 
    //   if x=0 stay in A, else go to B
    // State B transitions:
    //   always stay in B
    always @(*) begin
        next_state_A = state_A & (~x);
        next_state_B = state_A & x | state_B;
    end

    // Output logic (Mealy): z depends on current state and input x
    // From diagram:
    // In state A: z = x
    // In state B: z = ~x
    always @(*) begin
        z = (state_A & x) | (state_B & ~x);
    end

endmodule