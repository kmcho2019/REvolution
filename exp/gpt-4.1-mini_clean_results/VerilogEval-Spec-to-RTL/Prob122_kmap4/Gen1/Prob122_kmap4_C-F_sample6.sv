module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // The output is high when the parity of inputs a,b,c,d is odd.
    // This corresponds exactly to the given Karnaugh map pattern where
    // rows = cd and columns = ab in Gray code order.
    // The output matches the XOR of all four inputs.
    assign out = a ^ b ^ c ^ d;
endmodule