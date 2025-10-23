module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot state encoding: two flip-flops
reg state_A, state_B;
wire next_state_A, next_state_B;

// Next state logic using assign statements (combinational)
assign next_state_A = state_A & ~x;  // From A: stay in A if x=0, else move to B
assign next_state_B = state_A & x | state_B; // From B: always stay in B

// Output logic (Mealy FSM)
assign z = (state_A & x) | (state_B & ~x);

// State registers with asynchronous active-high reset
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