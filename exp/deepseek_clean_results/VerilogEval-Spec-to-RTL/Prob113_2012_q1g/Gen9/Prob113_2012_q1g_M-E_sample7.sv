module TopModule(
    input [3:0] x,
    output f
);
    // For x[3]=0: only true when x[2:0] is 000 or 010
    wire case_x3_0 = ~x[3] & ((~x[2] & ~x[1] & ~x[0]) | (~x[2] & x[1] & ~x[0]));
    
    // For x[3]=1:
    // When x[2]=1: true for all except x[1:0]=10
    wire case_x3_1_x2_1 = x[3] & x[2] & (x[1] | ~x[0]);
    
    // When x[2]=0: true when x[1]=0
    wire case_x3_1_x2_0 = x[3] & ~x[2] & ~x[1];
    
    assign f = case_x3_0 | case_x3_1_x2_1 | case_x3_1_x2_0;
endmodule