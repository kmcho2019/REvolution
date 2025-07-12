module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot state bits
reg state_A, state_B;
reg next_state_A, next_state_B;

// Next state logic (one-hot encoding)
// A transitions: A -> A if x=0, A -> B if x=1
// B transitions: B -> B regardless of x
always @(*) begin
    // Default next states to current states
    next_state_A = state_A;
    next_state_B = state_B;

    if (state_A) begin
        if (x == 1'b0) begin
            next_state_A = 1'b1;
            next_state_B = 1'b0;
        end else begin
            next_state_A = 1'b0;
            next_state_B = 1'b1;
        end
    end else if (state_B) begin
        // B stays B
        next_state_A = 1'b0;
        next_state_B = 1'b1;
    end else begin
        // Safety: default to A if both zero (invalid)
        next_state_A = 1'b1;
        next_state_B = 1'b0;
    end
end

// Output z depends on current state and x (Mealy output)
// z=1 when (A & x=1) or (B & x=0)
assign z = (state_A & x) | (state_B & ~x);

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1;  // reset to state A
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

endmodule