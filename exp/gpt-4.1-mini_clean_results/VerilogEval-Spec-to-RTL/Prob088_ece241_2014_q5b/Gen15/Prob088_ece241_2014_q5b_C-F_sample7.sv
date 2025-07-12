module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot encoded state: state_A=1 means state A; state_A=0 means state B
reg state_A;

// Next state logic: stay in A if x=0; else transition to B (state_A=0)
wire next_state_A = state_A & ~x;

// Output logic (Mealy): z=1 if in A and x=1 or in B and x=0
assign z = (state_A & x) | (~state_A & ~x);

// Sequential logic with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state_A <= 1'b1;  // Reset to state A
    else
        state_A <= next_state_A;
end

endmodule