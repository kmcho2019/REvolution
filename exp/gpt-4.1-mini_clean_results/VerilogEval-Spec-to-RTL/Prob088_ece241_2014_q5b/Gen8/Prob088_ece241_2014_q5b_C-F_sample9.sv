module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);
    // One-hot encoded states: state_A = 1 means state A; state_B = 1 means state B
    reg state_A, state_B;
    reg next_state_A, next_state_B;

    // Next state combinational logic
    always @(*) begin
        // Default hold states
        next_state_A = state_A;
        next_state_B = state_B;

        if (state_A) begin
            // From A: if x=1 go to B; else stay in A
            if (x) begin
                next_state_A = 1'b0;
                next_state_B = 1'b1;
            end else begin
                next_state_A = 1'b1;
                next_state_B = 1'b0;
            end
        end else begin
            // From B: stay in B regardless of x
            next_state_A = 1'b0;
            next_state_B = 1'b1;
        end
    end

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;  // Reset to state A
            state_B <= 1'b0;
        end else begin
            state_A <= next_state_A;
            state_B <= next_state_B;
        end
    end

    // Mealy output: z = (state_A & x) | (state_B & ~x)
    assign z = (state_A & x) | (state_B & ~x);

endmodule