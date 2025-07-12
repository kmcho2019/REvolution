module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot encoded states: state[0] = A, state[1] = B
reg [1:0] state;

// Output logic: z = x in A, z = ~x in B
assign z = state[0] ? x : ~x;

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01; // Reset to state A
    else begin
        // Explicit next-state logic fused from examples
        state[0] <= state[0] & (~x);
        state[1] <= (state[0] & x) | state[1];
    end
end

endmodule