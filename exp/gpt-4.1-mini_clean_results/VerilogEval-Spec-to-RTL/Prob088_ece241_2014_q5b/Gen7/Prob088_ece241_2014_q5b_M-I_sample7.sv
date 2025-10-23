module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // One-hot state encoding: two flip-flops
    reg state_A, state_B;

    // Next state signals
    reg next_A, next_B;
    reg next_z;

    // Combinational logic for next state and output
    always @* begin
        // Next state logic
        next_A = state_A & (~x);
        next_B = state_B | (state_A & x);

        // Mealy output logic
        // In A: z = x; in B: z = ~x
        next_z = (state_A) ? x : (~x);
    end

    // Sequential logic with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;  // Reset to state A
            state_B <= 1'b0;
            z       <= 1'b0;
        end else begin
            state_A <= next_A;
            state_B <= next_B;
            z       <= next_z;
        end
    end

endmodule