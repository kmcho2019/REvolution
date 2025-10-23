module TopModule(
    input a,
    input b,
    input c,
    output reg out
);

always @(*) begin
    out = (a) | ((~a) & (b | c));
end

endmodule