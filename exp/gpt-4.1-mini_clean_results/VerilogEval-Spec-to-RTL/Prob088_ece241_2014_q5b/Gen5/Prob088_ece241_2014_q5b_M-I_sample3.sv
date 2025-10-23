module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // One-hot state encoding: two flip-flops
    reg state_A, state_B;

    // Next state signals
    wire next_A, next_B;

    // State transition logic
    // From state A: if x=1 -> B, else stay A
    assign next_A = state_A & (~x);
    assign next_B = state_A & x | state_B; // stay in B once entered

    // Sequential logic with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;  // Reset to state A
            state_B <= 1'b0;
        end else begin
            state_A <= next_A;
            state_B <= next_B;
        end
    end

    // Output logic (Mealy)
    // In A: z = x; in B: z = ~x
    assign z = (state_A) ? x : (~x);

endmodule