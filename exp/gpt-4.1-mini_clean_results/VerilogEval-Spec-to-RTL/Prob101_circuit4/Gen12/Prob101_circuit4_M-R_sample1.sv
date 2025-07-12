module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Use conditional operator to produce q based on b or c being high
    assign q = (b == 1'b1) ? 1'b1 :
               (c == 1'b1) ? 1'b1 :
               1'b0;
endmodule