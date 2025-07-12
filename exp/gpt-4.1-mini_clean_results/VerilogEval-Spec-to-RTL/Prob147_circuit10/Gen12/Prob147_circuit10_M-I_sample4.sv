module TopModule (
    input  clk,
    input  a,
    input  b,
    output reg state,
    output q
);

wire next_state;

// Compute next state:
// next_state = (state XOR (b AND ~a)) AND NOT (b AND a)
// This means:
// - If b=1 and a=0, toggle state
// - If b=1 and a=1, reset state to 0
// - Else hold state
assign next_state = ((state ^ (b & ~a)) & ~(b & a));

assign q = state ^ b;

always @(posedge clk) begin
    state <= next_state;
end

endmodule