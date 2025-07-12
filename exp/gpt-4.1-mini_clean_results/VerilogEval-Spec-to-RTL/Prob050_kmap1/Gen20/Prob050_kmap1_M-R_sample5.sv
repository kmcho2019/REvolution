// TopModule implements the K-map function: out = a + b + c
module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    // Direct combinational assignment without intermediate wires
    // Logical function derived from K-map: out = a + b + c
    assign out = a | b | c;
endmodule