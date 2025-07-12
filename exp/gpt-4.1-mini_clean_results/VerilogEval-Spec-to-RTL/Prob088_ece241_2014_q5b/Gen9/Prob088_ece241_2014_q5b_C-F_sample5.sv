module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // One-hot state encoding: two bits, one per state
    // state_A = 1 means state A, state_B = 1 means state B
    reg state_A, state_B;
    reg next_state_A, next_state_B;

    // Next-state logic using one-hot encoding
    always @(*) begin
        // Default next states are zero (inactive)
        next_state_A = 1'b0;
        next_state_B = 1'b0;
        if (state_A) begin
            if (x)
                next_state_B = 1'b1; // A -> B if x=1
            else
                next_state_A = 1'b1; // A -> A if x=0
        end else if (state_B) begin
            next_state_B = 1'b1;     // B stays B regardless of x
        end else begin
            // Safety: if none active, reset to A (can rarely happen)
            next_state_A = 1'b1;
        end
    end

    // Output logic (Mealy): z depends on current state and input x
    assign z = (state_A && x) || (state_B && ~x);

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

endmodule