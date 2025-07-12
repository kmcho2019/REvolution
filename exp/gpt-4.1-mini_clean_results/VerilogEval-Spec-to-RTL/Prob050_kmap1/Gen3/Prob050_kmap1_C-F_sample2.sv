module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // From the Karnaugh map:
    // Output is 0 only when a=0, b=0, c=0.
    // For all other combinations, output = 1.
    // This logic is precisely implemented by:
    // out = a OR b OR c.
    assign out = a | b | c;

endmodule