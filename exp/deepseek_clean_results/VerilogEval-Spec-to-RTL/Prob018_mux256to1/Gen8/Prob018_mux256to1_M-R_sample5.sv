module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Directly select the bit using modulo-256 arithmetic
    assign out = in[sel];

endmodule