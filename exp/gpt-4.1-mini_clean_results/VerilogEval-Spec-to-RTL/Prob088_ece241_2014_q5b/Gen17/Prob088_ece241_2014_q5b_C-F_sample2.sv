module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

reg [1:0] state; // one-hot: state[0] = A, state[1] = B

// Next state combinational logic (one-hot)
// From A (state[0]):
//   x=0 -> A (01)
//   x=1 -> B (10)
// From B (state[1]):
//   stays in B (10)
wire next_A = state[0] & ~x;
wire next_B = (state[0] & x) | state[1];

wire [1:0] next_state = {next_B, next_A};

// Output logic (Mealy):
// z=0 in A when x=0
// z=1 in A when x=1
// z=1 in B when x=0
// z=0 in B when x=1
// Simplifies to: z = (state[0] & x) | (state[1] & ~x)
assign z = (state[0] & x) | (state[1] & ~x);

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01; // reset to A
    else
        state <= next_state;
end

endmodule