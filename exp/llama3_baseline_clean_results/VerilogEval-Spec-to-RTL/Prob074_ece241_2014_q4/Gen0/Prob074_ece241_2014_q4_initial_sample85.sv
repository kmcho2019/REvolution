module TopModule(
    input clk,
    input x,
    output z
);

reg qXor, qAnd, qOr;

always @(posedge clk) begin
    qXor <= x ^ qXor;
    qAnd <= x & ~qAnd;
    qOr <= x | ~qOr;
end

assign z = ~(qXor | qAnd | qOr);

initial begin
    qXor = 0;
    qAnd = 0;
    qOr = 0;
end

endmodule