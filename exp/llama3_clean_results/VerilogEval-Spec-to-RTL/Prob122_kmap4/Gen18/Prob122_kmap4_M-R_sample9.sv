module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Implementing the Karnaugh map logic using XOR operations with assign statement
    // This approach is concise and directly conveys the intent of continuous assignment
    assign out = (a ^ b) ^ (c ^ d);

endmodule