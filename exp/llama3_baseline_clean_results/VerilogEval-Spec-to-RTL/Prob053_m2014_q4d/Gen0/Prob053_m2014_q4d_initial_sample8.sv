module TopModule(
    input clk,
    input in,
    output reg out
);

reg q; // internal signal for D flip-flop output

always @(posedge clk) begin
    q <= in ^ out; // XOR operation
end

assign out = q; // continuous assignment for feedback

endmodule