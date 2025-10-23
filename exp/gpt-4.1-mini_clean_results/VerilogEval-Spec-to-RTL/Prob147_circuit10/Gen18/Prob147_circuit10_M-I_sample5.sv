module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

assign next_state = (state & ~a & ~b) | (~state & b);
assign q = (state & b) | (~state & a & ~b);

always @(posedge clk) begin
    state <= next_state;
end

endmodule