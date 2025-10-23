module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

always @(*)
begin
    out = b || (c == 0 && a == 1);
end

endmodule