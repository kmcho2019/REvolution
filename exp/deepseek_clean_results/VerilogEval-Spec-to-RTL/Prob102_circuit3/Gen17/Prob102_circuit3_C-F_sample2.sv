module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Hybrid implementation combining AOI efficiency with mux-like clarity
    assign q = (a | b) & (c | d);

endmodule