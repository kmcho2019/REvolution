module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // don't-care input, ignored in logic
    output reg out
);

// Implement the logic using an always_comb block (Verilog-2001 style)
always @* begin
    // out = a OR (c AND NOT b)
    out = a | (c & ~b);
    // 'd' is don't-care and omitted intentionally
end

endmodule