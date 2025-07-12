module TopModule (
    input wire a,
    input wire b,
    output wire out
);
    // Direct continuous assignment implementing AND function
    assign out = a & b;
endmodule