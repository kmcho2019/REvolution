module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't care, ignored
    output reg out
);

always @(*) begin
    out = a | (c & ~b);
end

endmodule