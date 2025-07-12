module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // One-hot state encoding: two flip-flops
    reg state_A, state_B;

    // Next state signals
    wire next_A, next_B;

    // Asynchronous active-high reset with one-hot state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;  // reset to state A
            state_B <= 1'b0;
        end else begin
            state_A <= next_A;
            state_B <= next_B;
        end
    end

    // Next state logic combinational
    // State A: if x=0 stay in A; if x=1 go to B
    // State B: stay in B always
    assign next_A = (state_A & ~x);
    assign next_B = (state_A & x) | state_B;

    // Output logic (Mealy): 
    // From state A: z = x
    // From state B: z = ~x
    assign z = (state_A & x) | (state_B & ~x);

endmodule