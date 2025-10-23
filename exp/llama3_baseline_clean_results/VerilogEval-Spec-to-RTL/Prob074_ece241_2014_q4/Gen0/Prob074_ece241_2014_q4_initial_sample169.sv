module TopModule(
    input clk,
    input x,
    output z
);

reg qXor, qAnd, qOr;

always @(posedge clk) begin
    qXor <= x ^ qXor;
    qAnd <= x & (~qAnd);
    qOr  <= x | (~qOr);
end

wire xorOut, andOut, orOut;

assign xorOut = x ^ qXor;
assign andOut = x & (~qAnd);
assign orOut  = x | (~qOr);

assign z = ~(xorOut | andOut | orOut);

initial begin
    qXor = 0;
    qAnd = 0;
    qOr  = 0;
end

endmodule