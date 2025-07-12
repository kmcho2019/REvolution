module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

reg [1:0] state; // state[0] = A, state[1] = B (one-hot)

// Next state logic
wire [1:0] next_state = (state[0]) ? (x ? 2'b10 : 2'b01) : 2'b10;

// Output logic: z = x if in A, else ~x
assign z = state[0] ? x : ~x;

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01; // reset to A
    else
        state <= next_state;
end

endmodule