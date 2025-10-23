module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // The Karnaugh map corresponds to a 4-input XOR function.
    // Direct continuous assignment is optimal in clarity and hardware efficiency.
    assign out = a ^ b ^ c ^ d;
endmodule