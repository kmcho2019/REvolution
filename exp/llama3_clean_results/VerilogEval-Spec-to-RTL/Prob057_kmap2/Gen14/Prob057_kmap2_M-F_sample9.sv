module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

always @(*)
begin
    out = (a & b & ~d) | (~a & ~b & ~c & ~d) | (a & ~b & d) | (~a & b & d) | (~a & ~c & d);
end

endmodule