module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

// One-hot encoded states: two flip-flops for states A and B
reg state_A, state_B;
reg next_state_A, next_state_B;

// Next state and output logic (combinational)
always @(*) begin
    // Default next states to zero to avoid latches
    next_state_A = 1'b0;
    next_state_B = 1'b0;
    z = 1'b0;

    if (state_A) begin
        // From state A
        if (x == 1'b0) begin
            next_state_A = 1'b1;
            z = 1'b0;
        end else begin
            next_state_B = 1'b1;
            z = 1'b1;
        end
    end else if (state_B) begin
        // From state B
        next_state_B = 1'b1;
        z = (x == 1'b0) ? 1'b1 : 1'b0;
    end else begin
        // Defensive: no state active, default to A on next clock
        next_state_A = 1'b1;
        z = 1'b0;
    end
end

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1; // Reset to state A
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

endmodule