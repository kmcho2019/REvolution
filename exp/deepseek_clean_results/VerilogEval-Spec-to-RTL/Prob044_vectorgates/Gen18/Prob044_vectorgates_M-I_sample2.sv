module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Direct bitwise OR implementation (more efficient than NOT-NOR)
    assign out_or_bitwise = a | b;
    
    // Simplified logical OR using reduction operators
    assign out_or_logical = (|a) || (|b);
    
    // Combined NOT operations with proper concatenation
    assign out_not = {~b, ~a};
endmodule