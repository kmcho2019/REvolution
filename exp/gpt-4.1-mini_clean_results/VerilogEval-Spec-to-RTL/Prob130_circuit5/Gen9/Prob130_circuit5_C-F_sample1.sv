module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    // Select q based on c: for c=0..3 select b, e, a, d respectively; else 4'hF
    assign q = (c < 4) ? 
               ((c == 4'd0) ? b :
                (c == 4'd1) ? e :
                (c == 4'd2) ? a :
                              d)
               : 4'hF;

endmodule