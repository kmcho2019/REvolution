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
    if (b == 1) out = 1; // 'out' is 1 whenever 'b' is 1
    else if (a == 1 && c == 0) out = 1; // Additional condition for 'b' being 0
end

endmodule