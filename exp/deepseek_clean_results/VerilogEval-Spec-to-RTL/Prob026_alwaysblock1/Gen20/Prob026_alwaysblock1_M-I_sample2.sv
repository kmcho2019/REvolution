module TopModule (
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);
    // Continuous assignment implementation
    assign out_assign = a & b;
    
    // Always block implementation
    always @(*) out_alwaysblock = a & b;
endmodule