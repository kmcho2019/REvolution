module TopModule(
    input [3:0] x,  // x[3], x[2], x[1], x[0] - but we only use x[3:1] per problem statement
    output f
);
    assign f = x[3] |                // When x[3]=1 (rows 11 and 10)
               (x[2] & x[1] & x[0]) |  // When x[3]x[4]=01 and x[1]x[2]=11
               (~x[2] & ~x[1] & x[0]); // When x[3]x[4]=00 and x[1]x[2]=01
endmodule