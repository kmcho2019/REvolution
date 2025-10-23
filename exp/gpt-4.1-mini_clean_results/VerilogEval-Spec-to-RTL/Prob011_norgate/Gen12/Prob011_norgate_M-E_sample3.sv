module TopModule (
    input  a,
    input  b,
    output out
);
    wire or_out;  // Intermediate wire between OR and NOT gate

    // Instantiate OR gate primitive
    or or_gate (or_out, a, b);

    // Instantiate NOT gate primitive
    not not_gate (out, or_out);

endmodule