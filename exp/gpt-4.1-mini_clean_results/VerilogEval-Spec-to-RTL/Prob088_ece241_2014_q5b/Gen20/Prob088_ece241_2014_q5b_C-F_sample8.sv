module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot encoded states: state[0] = A, state[1] = B
reg [1:0] state;

// Next state logic signals for clarity
wire next_state_A = state[0] & ~x;
wire next_state_B = (state[0] & x) | state[1];

// Mealy output logic: z = x when in A, else ~x in B
assign z = state[0] ? x : ~x;

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01; // Reset to state A (one-hot)
    else
        state <= {next_state_B, next_state_A};
end

endmodule