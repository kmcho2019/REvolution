module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Create the two possible row patterns
    wire pattern1 = ~a & ~b ? 1'b0 :
                    ~a &  b ? 1'b1 :
                     a &  b ? 1'b0 :
                    1'b1;  // a & ~b
    
    wire pattern2 = ~a & ~b ? 1'b1 :
                    ~a &  b ? 1'b0 :
                     a &  b ? 1'b1 :
                    1'b0;  // a & ~b
    
    // Select pattern based on cd combination
    assign out = (c ^ d) ? pattern2 : pattern1;
endmodule