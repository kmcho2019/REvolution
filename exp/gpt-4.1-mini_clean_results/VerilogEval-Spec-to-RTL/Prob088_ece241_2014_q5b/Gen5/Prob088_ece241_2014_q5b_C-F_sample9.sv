module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // One-hot encoding: 2 bits, only one bit high per state
    // state_A = 1 means state A active
    // state_B = 1 means state B active
    reg state_A, state_B;
    reg next_state_A, next_state_B;

    // Next-state logic combinational block
    always @(*) begin
        // Default next state 0 (no state active), to avoid latches
        next_state_A = 1'b0;
        next_state_B = 1'b0;
        
        if (state_A) begin
            // From state A
            if (x)
                next_state_B = 1'b1;  // Go to B if x=1
            else
                next_state_A = 1'b1;  // Stay in A if x=0
        end else if (state_B) begin
            // From state B, stays in B regardless of x
            next_state_B = 1'b1;
        end else begin
            // Safety: if no valid state, reset to A
            next_state_A = 1'b1;
        end
    end

    // State registers with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;   // reset to state A
            state_B <= 1'b0;
        end else begin
            state_A <= next_state_A;
            state_B <= next_state_B;
        end
    end

    // Output logic Mealy: z depends on current state and input x
    // According to spec:
    // A -- x=0 (z=0), x=1 (z=1)
    // B -- x=0 (z=1), x=1 (z=0)
    assign z = (state_A && x) || (state_B && ~x);

endmodule