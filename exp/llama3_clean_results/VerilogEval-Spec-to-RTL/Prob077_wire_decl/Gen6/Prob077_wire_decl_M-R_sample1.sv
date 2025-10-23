module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out,
    output reg out_n
);

wire and_result1, and_result2;

always @(*) begin
    and_result1 = a & b;
    and_result2 = c & d;
    out = and_result1 | and_result2;
    out_n = ~out;
end

endmodule