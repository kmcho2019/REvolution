module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

assign q = (state & b) | (~state & a);

always @(posedge clk) begin
    state <= q;
end

endmodule