module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot state encoding with two flip-flops
reg state_A, state_B;

// Next state logic: state_A stays if x=0, else transition to state_B; state_B remains until reset
wire next_state_A = state_A & ~x;
wire next_state_B = (state_A & x) | state_B;

// Sequential logic with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1;  // Reset to state A
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

// Mealy output z: z=1 if in state A and x=1, or in state B and x=0; else z=0
assign z = state_A ? x : ~x;

endmodule