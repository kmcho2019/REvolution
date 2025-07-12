module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    // Implement out = ~(~a & ~b & ~c)
    wire not_a, not_b, not_c;
    wire all_zero;

    assign not_a = ~a;
    assign not_b = ~b;
    assign not_c = ~c;

    assign all_zero = not_a & not_b & not_c;

    assign out = ~all_zero;
endmodule