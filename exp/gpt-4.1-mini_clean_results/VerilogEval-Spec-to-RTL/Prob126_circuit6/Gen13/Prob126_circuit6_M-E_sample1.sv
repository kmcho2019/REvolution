module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    // Use nested ternary operators based on bits of 'a' to assign q combinationally
    assign q = (a[2] == 1'b0) ?
                 ((a[1] == 1'b0) ?
                    ((a[0] == 1'b0) ? 16'h1232 : 16'haee0)  // a=0 or 1
                  : ((a[0] == 1'b0) ? 16'h27d4 : 16'h5a0e)) // a=2 or 3
              : ((a[1] == 1'b0) ?
                    ((a[0] == 1'b0) ? 16'h2066 : 16'h64ce)  // a=4 or 5
                  : ((a[0] == 1'b0) ? 16'hc526 : 16'h2f19)); // a=6 or 7

endmodule