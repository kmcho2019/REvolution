module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // d is don't-care, ignored in logic
    output reg out
);

always @(*) begin
    out = a | (c & ~b);
end

endmodule