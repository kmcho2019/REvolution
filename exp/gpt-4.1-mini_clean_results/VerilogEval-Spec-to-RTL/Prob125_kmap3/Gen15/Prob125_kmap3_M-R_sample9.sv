module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't care input, ignored in logic
    output reg out
);

always @(*) begin
    out = a | (c & ~b);
end

endmodule