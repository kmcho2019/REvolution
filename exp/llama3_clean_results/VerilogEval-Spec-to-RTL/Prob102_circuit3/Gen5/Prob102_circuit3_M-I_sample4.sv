module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);

always @(*) begin
    q = b | d;
end

endmodule