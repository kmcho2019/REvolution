module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

assign q = state ^ b;

always @(posedge clk) begin
    state <= (state & ~a) | (~state & a & ~b);
end

endmodule