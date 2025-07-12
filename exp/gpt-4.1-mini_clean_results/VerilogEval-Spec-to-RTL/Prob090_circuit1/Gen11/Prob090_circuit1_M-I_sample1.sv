module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct assignment to implement AND function efficiently
    assign q = a & b;
endmodule