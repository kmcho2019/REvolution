module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot encoding with a single bit: state_A=1 means state A, 0 means state B
reg state_A, next_state_A;

// Next state logic
always @(*) begin
    if (state_A)
        next_state_A = ~x;  // from A: stay in A if x=0, else go to B (state_A=0)
    else
        next_state_A = 1'b0; // from B: stay in B
end

// Output logic (Mealy)
assign z = (state_A && x) || (~state_A && ~x);

// State register with async active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state_A <= 1'b1;  // reset to state A
    else
        state_A <= next_state_A;
end

endmodule