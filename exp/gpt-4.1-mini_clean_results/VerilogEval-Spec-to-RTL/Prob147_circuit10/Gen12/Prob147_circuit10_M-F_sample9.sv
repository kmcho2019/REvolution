module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

assign q = (b & ~state) | (a & state);

always @(posedge clk) begin
    state <= q;
end

initial begin
    state = 1'b0;
end

endmodule