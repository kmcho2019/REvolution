module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

reg next_state;

assign q = (state & ~b) | (~state & (a ^ b));

always @(posedge clk) begin
    next_state <= (state & ~b) | (~state & (a ^ b));
    state <= next_state;
end

endmodule