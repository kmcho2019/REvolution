module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Direct implementation using case statement
    // Synthesis tools typically optimize this well for multiplexers
    assign out = in[sel];

endmodule