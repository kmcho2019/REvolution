module TopModule (
    input  a, b, c, d,
    output q
);
    // Novel implementation with priority-based decision tree
    wire stage1 = a ? d : 1'b0;
    wire stage2 = stage1 ? stage1 : (b | c);
    
    assign q = stage2;
endmodule