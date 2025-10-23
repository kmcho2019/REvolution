module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;
assign next_state = (state ^ a) & ~b;
assign q = ~(state & a);

always @(posedge clk) begin
    state <= next_state;
end

endmodule