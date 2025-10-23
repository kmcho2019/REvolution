module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot encoding: state[1] = A, state[0] = B
reg [1:0] state;

// Next state logic
wire [1:0] next_state;
assign next_state[1] = (state[1] & ~x) | (state[0] & 1'b0); // A->A if x=0; B->A never (0)
assign next_state[0] = (state[1] & x)    | (state[0] & 1'b1); // A->B if x=1; B->B always (1)

// Output logic (Mealy FSM)
assign z = (state[1] & x) | (state[0] & ~x);

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b10; // Reset to state A (one-hot: 10)
    else
        state <= next_state;
end

endmodule