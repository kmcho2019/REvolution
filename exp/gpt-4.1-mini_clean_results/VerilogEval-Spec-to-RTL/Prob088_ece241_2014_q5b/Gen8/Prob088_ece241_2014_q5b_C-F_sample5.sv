module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// State register: single flip-flop represents state_A (1 = state A, 0 = state B)
// state_B is the complement of state_A to maintain one-hot semantics
reg state_A;
wire state_B = ~state_A;

// Next state logic
wire next_state_A = state_A & ~x; // from A: stay in A if x=0, else go to B (state_A=0)

// Output logic (Mealy)
assign z = (state_A & x) | (state_B & ~x);

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state_A <= 1'b1; // reset into state A
    else
        state_A <= next_state_A;
end

endmodule