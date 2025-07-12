module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot state encoding:
// state_A=1, state_B=0 means state A
// state_A=0, state_B=1 means state B
reg state_A, state_B;
reg next_state_A, next_state_B;

// Next state logic (combinational)
always @(*) begin
    // Default next state: remain in current state
    next_state_A = 0;
    next_state_B = 0;
    
    if (state_A) begin
        // From A:
        // If x=0 stay in A, else go to B
        if (x == 1'b0) begin
            next_state_A = 1'b1;
            next_state_B = 1'b0;
        end else begin
            next_state_A = 1'b0;
            next_state_B = 1'b1;
        end
    end else if (state_B) begin
        // From B:
        // Always stay in B regardless of x
        next_state_A = 1'b0;
        next_state_B = 1'b1;
    end else begin
        // Should never happen; default reset state
        next_state_A = 1'b1;
        next_state_B = 1'b0;
    end
end

// Output logic (Mealy FSM)
assign z = (state_A && x) || (state_B && ~x);

// State registers with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1; // reset to A
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

endmodule