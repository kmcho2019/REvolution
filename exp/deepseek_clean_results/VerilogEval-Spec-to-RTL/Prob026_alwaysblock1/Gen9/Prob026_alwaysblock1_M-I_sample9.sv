module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Direct continuous assignment
    assign out_assign = a & b;
    
    // Combinational always block without reg declaration
    always @(*) out_alwaysblock = a & b;
endmodule