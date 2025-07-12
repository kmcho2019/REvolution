module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Direct selection using case statement
    // This allows the synthesizer to choose the optimal implementation
    assign out = in[sel];

endmodule