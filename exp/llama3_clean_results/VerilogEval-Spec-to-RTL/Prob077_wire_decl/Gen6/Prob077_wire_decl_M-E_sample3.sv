module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out,
    output reg out_n
);

always @(*) begin
    out = (a & b) | (c & d);
    out_n = ~out;
end

endmodule