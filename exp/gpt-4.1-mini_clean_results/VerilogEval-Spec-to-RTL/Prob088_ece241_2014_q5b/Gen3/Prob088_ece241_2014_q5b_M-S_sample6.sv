module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot state encoding: two flip-flops
reg state_A, state_B;
reg next_state_A, next_state_B;

// Next state logic
always @(*) begin
    // Default assignments
    next_state_A = 1'b0;
    next_state_B = 1'b0;
    if (state_A) begin
        if (x)
            next_state_B = 1'b1;  // A->B on x=1
        else
            next_state_A = 1'b1;  // Stay in A
    end else begin // state_B == 1
        next_state_B = 1'b1;      // Stay in B regardless of x
    end
end

// Output logic (Mealy)
assign z = (state_A && x) || (state_B && ~x);

// State registers with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1;  // Reset to A
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

endmodule