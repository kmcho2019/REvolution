module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// State register: single flip-flop represents state_A (1 = state A, 0 = state B)
// state_B is derived combinationally as complement of state_A to maintain one-hot encoding
reg state_A;
wire state_B = ~state_A;

// Next state logic
wire next_state_A = state_A & ~x;

// Output logic (Mealy): z=1 when (state A and x=1) or (state B and x=0)
assign z = (state_A & x) | (state_B & ~x);

// State update with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state_A <= 1'b1;  // Reset to state A
    else
        state_A <= next_state_A;
end

endmodule