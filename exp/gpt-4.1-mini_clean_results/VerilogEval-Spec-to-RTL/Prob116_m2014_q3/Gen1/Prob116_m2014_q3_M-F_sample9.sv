module TopModule(
    input [3:0] x,
    output f
);
    // Reinterpret bits as per the corrected mapping:
    // row bits: {x[3], x[2]}
    // col bits: {x[1], x[0]}
    
    // K-map groups:
    // Group 1 (4-cell group):
    //   rows 10(2),11(3), cols 00(0),01(1)
    //   => x[3] = 1, x[0] = 0  (x[3] & ~x[0])
    //
    // Single 1 at (01,11):
    //   x[3]=0, x[2]=1, x[1]=1, x[0]=1
    //   => ~x[3] & x[2] & x[1] & x[0]
    
    assign f = (x[3] & ~x[0]) | (~x[3] & x[2] & x[1] & x[0]);
endmodule