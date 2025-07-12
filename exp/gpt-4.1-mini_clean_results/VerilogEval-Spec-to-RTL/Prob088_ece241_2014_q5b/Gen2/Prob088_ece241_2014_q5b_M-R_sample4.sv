module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot state bits
reg state_A, state_B;
reg next_state_A, next_state_B;

// Next state logic (combinational)
always @(*) begin
    // Default next states to 0
    next_state_A = 1'b0;
    next_state_B = 1'b0;

    // From state A
    if (state_A) begin
        if (x == 1'b0) begin
            next_state_A = 1'b1; // stay in A
        end else begin
            next_state_B = 1'b1; // go to B
        end
    end
    // From state B
    else if (state_B) begin
        // B state stays in B regardless of x
        next_state_B = 1'b1;
    end
    else begin
        // If in invalid state, reset to A
        next_state_A = 1'b1;
    end
end

// State registers with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1;  // Reset to state A
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

// Output logic (Mealy output): z depends on state and input x
assign z = (state_A & x) | (state_B & ~x);

endmodule