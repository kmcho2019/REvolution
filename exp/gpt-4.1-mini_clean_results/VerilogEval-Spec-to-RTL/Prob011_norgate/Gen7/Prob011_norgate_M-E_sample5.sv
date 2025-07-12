module TopModule (
    input  a,
    input  b,
    output out
);
    wire or_out;

    or or_gate (or_out, a, b);
    not not_gate (out, or_out);
endmodule