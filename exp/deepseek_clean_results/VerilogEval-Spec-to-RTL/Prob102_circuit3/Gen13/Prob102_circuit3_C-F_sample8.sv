module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Optimal implementation: q = b OR d
    assign q = b | d;

endmodule