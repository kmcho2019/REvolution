module TopModule(
    input  a,
    input  b,
    output reg out
);

reg not_a, not_b;

always @(*)
begin
    not_a = ~a;
    not_b = ~b;
    out = not_a & not_b;
end

endmodule