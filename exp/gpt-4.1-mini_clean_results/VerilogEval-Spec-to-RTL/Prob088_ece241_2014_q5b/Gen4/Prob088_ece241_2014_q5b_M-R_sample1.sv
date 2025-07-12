module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

reg state_A, state_B;
reg next_state_A, next_state_B;

// Next-state logic (combinational)
always @(*) begin
    // Default assignments to avoid inferred latches
    next_state_A = 1'b0;
    next_state_B = 1'b0;

    if (state_A) begin
        if (x == 1'b0) begin
            next_state_A = 1'b1; // Stay in A
        end else begin
            next_state_B = 1'b1; // Move to B
        end
    end else if (state_B) begin
        // From B, always stay in B regardless of x
        next_state_B = 1'b1;
    end else begin
        // Should never happen; default to A
        next_state_A = 1'b1;
    end
end

// Sequential logic with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1;
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

// Output logic (Mealy)
assign z = (state_A && x) || (state_B && ~x);

endmodule