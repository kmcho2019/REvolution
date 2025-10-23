module TopModule (
    input [2:0] a,
    output [15:0] q
);

assign q = (a == 0) ? 16'h1232 :
           (a == 1) ? 16'haee0 :
           (a == 2) ? 16'h27d4 :
           (a == 3) ? 16'h5a0e :
           (a == 4) ? 16'h2066 :
           (a == 5) ? 16'h64ce :
           (a == 6) ? 16'hc526 :
                      16'h2f19;  // a == 7

endmodule