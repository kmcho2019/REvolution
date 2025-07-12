module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Direct assignment using case statement
    assign out = in[sel];

endmodule