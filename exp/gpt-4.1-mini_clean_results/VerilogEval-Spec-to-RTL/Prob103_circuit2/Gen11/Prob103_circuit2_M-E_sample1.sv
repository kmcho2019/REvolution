module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Initialize parity assuming zero ones -> output 1 (even parity)
    // For each input bit that is '1', toggle the parity output

    assign q = (a == 1'b1) ? 
                 ((b == 1'b1) ? 
                     ((c == 1'b1) ? 
                         ((d == 1'b1) ? 1'b1 : 1'b0)
                      : 
                         ((d == 1'b1) ? 1'b0 : 1'b1))
                  : 
                     ((c == 1'b1) ? 
                         ((d == 1'b1) ? 1'b0 : 1'b1)
                      : 
                         ((d == 1'b1) ? 1'b1 : 1'b0)))
              : 
                 ((b == 1'b1) ? 
                     ((c == 1'b1) ? 
                         ((d == 1'b1) ? 1'b0 : 1'b1)
                      : 
                         ((d == 1'b1) ? 1'b1 : 1'b0))
                  : 
                     ((c == 1'b1) ? 
                         ((d == 1'b1) ? 1'b1 : 1'b0)
                      : 
                         ((d == 1'b1) ? 1'b0 : 1'b1)));

endmodule