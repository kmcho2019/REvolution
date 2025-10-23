module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

reg [1:0] state; // one-hot: state[0] = A, state[1] = B

// Next state combinational logic
wire [1:0] next_state;
assign next_state[0] = state[0] & ~x; // stay in A if x=0
assign next_state[1] = (state[0] & x) | state[1]; // to B if from A and x=1, or stay in B

// Output logic (Mealy)
wire z_comb;
assign z_comb = (state[0] & x) | (state[1] & ~x);

assign z = z_comb;

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01; // Reset to A
    else
        state <= next_state;
end

endmodule