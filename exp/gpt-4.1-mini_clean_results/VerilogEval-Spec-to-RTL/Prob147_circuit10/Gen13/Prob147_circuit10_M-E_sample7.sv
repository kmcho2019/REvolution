module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;
wire q_internal;

// When b=1, state resets to 0 (next_state=0).
// When b=0, next_state toggles if a=1 (state XOR a), else holds.
assign next_state = b ? 1'b0 : (state ^ a);

// Output q is high if (state=1 and b=1) or (a=1 and state=0)
assign q_internal = (state & b) | (a & ~state);

always @(posedge clk) begin
    state <= next_state;
end

assign q = q_internal;

initial begin
    state = 1'b0;
end

endmodule