module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;
assign next_state = (a & b) | (state & ~a);
assign q = state ^ b;

always @(posedge clk) begin
    state <= next_state;
end

endmodule