module TopModule (
    input  a,
    input  b,
    input  c,
    input  d, // don't-care input, unused in logic
    output reg out
);

always @(*) begin
    // Output is 1 if 'a' is high, or 'c' is high and 'b' is low.
    // The input 'd' is don't-care and ignored.
    out = a | (c & ~b);
end

endmodule