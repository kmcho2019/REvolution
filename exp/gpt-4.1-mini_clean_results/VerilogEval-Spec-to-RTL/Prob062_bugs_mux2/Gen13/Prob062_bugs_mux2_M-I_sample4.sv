module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    // Bitwise 2-to-1 mux of vectors a and b, then reduction OR to single bit output
    assign out = |( (~sel & a) | (sel & b) );

endmodule