module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

always @(*)
begin
    out = 0;
    if (c == 0 && b == 1) out = 1;
    if (c == 1 && b == 1) out = 1;
end

endmodule