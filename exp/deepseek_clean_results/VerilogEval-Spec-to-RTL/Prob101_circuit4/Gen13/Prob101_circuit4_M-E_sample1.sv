module TopModule (
    input  a, b, c, d,
    output q
);
    // Priority-based implementation:
    // 1. a has highest priority (when 1, q=0)
    // 2. Then b (when 1, q=1)
    // 3. Finally c (d unused)
    assign q = (a == 1'b1) ? 1'b0 : 
               (b == 1'b1) ? 1'b1 :
               (c == 1'b1) ? 1'b1 : 1'b0;
endmodule