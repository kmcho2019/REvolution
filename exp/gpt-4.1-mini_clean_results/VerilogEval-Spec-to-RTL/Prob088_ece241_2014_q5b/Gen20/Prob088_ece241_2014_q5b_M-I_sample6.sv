module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

// One-hot encoded states
// state_a = 1 means state A
// state_b = 1 means state B
reg state_a, state_b;
reg next_state_a, next_state_b;

// Combined combinational logic for next state and output
always @(*) begin
    // Default assignments
    next_state_a = state_a;
    next_state_b = state_b;
    z = 1'b0;

    if (state_a) begin
        // From state A
        if (x == 1'b0) begin
            next_state_a = 1'b1;
            next_state_b = 1'b0;
            z = 1'b0;
        end else begin
            next_state_a = 1'b0;
            next_state_b = 1'b1;
            z = 1'b1;
        end
    end else if (state_b) begin
        // From state B
        next_state_a = 1'b0;
        next_state_b = 1'b1;
        z = (x == 1'b0) ? 1'b1 : 1'b0;
    end else begin
        // Safety: if no state is high (should not happen), reset to A
        next_state_a = 1'b1;
        next_state_b = 1'b0;
        z = 1'b0;
    end
end

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_a <= 1'b1; // Reset state A
        state_b <= 1'b0;
    end else begin
        state_a <= next_state_a;
        state_b <= next_state_b;
    end
end

endmodule