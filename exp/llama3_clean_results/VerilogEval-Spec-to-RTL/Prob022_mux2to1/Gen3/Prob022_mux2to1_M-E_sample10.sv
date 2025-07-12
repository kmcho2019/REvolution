module TopModule(
    input  a,
    input  b,
    input  sel,
    output reg out
);

always @(*)
begin
    out = (a & ~sel) | (b & sel);
end

endmodule