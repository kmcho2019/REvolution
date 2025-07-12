module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,       // don't-care input, ignored
    output reg out
);

always @(*) begin
    // Local inverted signals for clarity and minimal logic
    wire not_c = ~c;
    wire not_b = ~b;

    // Compute intermediate terms based on Karnaugh map simplification
    wire and_notc_a = not_c & a;       // Covers c=0 row when a=1
    wire or_term = not_b | a;          // Covers c=1 cases where b=0 or a=1
    wire and_c_or = c & or_term;

    // Final output combines both conditions
    out = and_notc_a | and_c_or;
end

endmodule