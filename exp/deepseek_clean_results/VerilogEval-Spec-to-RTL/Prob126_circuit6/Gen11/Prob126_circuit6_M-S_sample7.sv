module TopModule (
    input [2:0] a,
    output [15:0] q
);

assign q = (a == 3'h0) ? 16'h1232 :
           (a == 3'h1) ? 16'haee0 :
           (a == 3'h2) ? 16'h27d4 :
           (a == 3'h3) ? 16'h5a0e :
           (a == 3'h4) ? 16'h2066 :
           (a == 3'h5) ? 16'h64ce :
           (a == 3'h6) ? 16'hc526 :
                          16'h2f19; // default case (3'h7)

endmodule