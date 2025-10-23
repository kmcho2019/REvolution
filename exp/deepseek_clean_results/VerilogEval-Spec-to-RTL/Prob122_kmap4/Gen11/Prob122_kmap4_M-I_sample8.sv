module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Optimal XOR-based implementation matching the Karnaugh map
    assign out = (a ^ b) ^ (c ^ d);
endmodule