module TopModule #(
    parameter RESET_VAL = 1'b0
)(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    q <= r ? RESET_VAL : d;
end

endmodule