module TopModule (
    input [2:0] a,
    output [15:0] q
);

assign q = 
    (a == 3'd0) ? 16'h1232 :  // 0 -> 1232
    (a == 3'd1) ? 16'haee0 :  // 1 -> aee0
    (a == 3'd2) ? 16'h27d4 :  // 2 -> 27d4
    (a == 3'd3) ? 16'h5a0e :  // 3 -> 5a0e
    (a == 3'd4) ? 16'h2066 :  // 4 -> 2066
    (a == 3'd5) ? 16'h64ce :  // 5 -> 64ce
    (a == 3'd6) ? 16'hc526 :  // 6 -> c526
    (a == 3'd7) ? 16'h2f19 :  // 7 -> 2f19
                   16'h0000;   // default (shouldn't occur)

endmodule