module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Directly select the output bit using concatenation and indexing
    // This combines group selection and bit selection in one efficient operation
    assign out = in[{sel[7:4], sel[3:0]}];

endmodule