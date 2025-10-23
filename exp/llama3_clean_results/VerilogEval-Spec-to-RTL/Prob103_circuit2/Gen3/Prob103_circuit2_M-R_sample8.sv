module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);

always @(*) begin
    reg temp;
    temp = a ^ b;
    temp = temp ^ c;
    temp = temp ^ d;
    q = ~temp;
end

endmodule