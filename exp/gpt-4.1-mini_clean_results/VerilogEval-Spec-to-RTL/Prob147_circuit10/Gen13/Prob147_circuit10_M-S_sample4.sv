module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

always @(posedge clk) begin
    state <= state ^ (a & b);
end

assign q = a & state;

endmodule