module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

assign q = (a & ~state) | (b & state);

always @(posedge clk) begin
    state <= q;
end

endmodule