module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Direct assign implementation
    assign out_assign = a & b;
    
    // Direct always block implementation
    always @(*) out_alwaysblock = a & b;
endmodule