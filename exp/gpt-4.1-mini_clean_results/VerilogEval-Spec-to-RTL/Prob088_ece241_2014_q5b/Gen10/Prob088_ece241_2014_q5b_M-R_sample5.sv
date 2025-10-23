module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot state encoding: two flip-flops representing states A and B
reg state_A, state_B;

// Next state signals
wire next_state_A, next_state_B;

// Next state logic based on current state and input x
assign next_state_A = (state_A & ~x);      // Stay in A if x=0, else go to B
assign next_state_B = (state_A & x) | state_B; // Go to B if from A and x=1, else stay in B

// Mealy output logic
assign z = (state_A & x) | (state_B & ~x);

// State update with asynchronous active-high reset
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