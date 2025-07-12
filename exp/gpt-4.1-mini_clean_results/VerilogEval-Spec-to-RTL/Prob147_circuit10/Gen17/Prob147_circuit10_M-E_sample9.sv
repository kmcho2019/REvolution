module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

// State toggles when b=1 and a=0
assign next_state = state ^ (b & ~a);

// Output q is high when state is 1 and a=0, or when b=1
assign q = (state & ~a) | b;

always @(posedge clk) begin
    state <= next_state;
end

endmodule