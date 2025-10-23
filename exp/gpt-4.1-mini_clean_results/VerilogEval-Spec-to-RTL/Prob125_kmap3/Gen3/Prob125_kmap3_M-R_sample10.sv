module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // don't-care input, ignored in logic
    output out
);

reg out_reg;

always @(*) begin
    // Implement same logic as: out = a | (c & ~b);
    out_reg = a | (c & ~b);
end

assign out = out_reg;

endmodule