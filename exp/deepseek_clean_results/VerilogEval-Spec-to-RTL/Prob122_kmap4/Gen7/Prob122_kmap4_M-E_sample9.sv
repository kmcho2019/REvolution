module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Use ab as select lines for 4-to-1 mux
    // Each mux input is a function of cd that matches the K-map columns
    assign out = (~a & ~b) ? (c ^ d) :  // Column 00: c XOR d
                (~a &  b) ? ~(c ^ d) :  // Column 01: NOT (c XOR d)
                ( a &  b) ? (c ^ d) :  // Column 11: c XOR d
                            ~(c ^ d);   // Column 10: NOT (c XOR d)
endmodule