module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Direct implementation using assign statement
    assign out_assign = a & b;
    
    // Direct implementation using always block
    always @(*) out_alwaysblock = a & b;
endmodule