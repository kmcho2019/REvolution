module TopModule(
    input  clk,
    input  in,
    output reg out
);

reg q;

always @(posedge clk) begin
    q <= in ^ out;
end

assign out = q;

endmodule