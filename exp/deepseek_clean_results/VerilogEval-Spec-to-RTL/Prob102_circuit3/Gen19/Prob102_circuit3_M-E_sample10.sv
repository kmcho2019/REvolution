module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Treat {a,b} as 2-bit selector
    // Each mux input represents a case where at least one of {c,d} is 1
    assign q = (a & b) ? (c | d) :  // When both a and b are 1
              (a) ? (c | d) :       // When only a is 1
              (b) ? (c | d) :       // When only b is 1
              0;                    // When neither a nor b is 1

endmodule