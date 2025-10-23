module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Bitwise OR - direct assignment
    assign out_or_bitwise = a | b;
    
    // Logical OR - reduction OR of both inputs
    assign out_or_logical = (|a) || (|b);
    
    // Combined NOT operations with concatenation
    // b inverse in upper bits [5:3], a inverse in lower bits [2:0]
    assign out_not = {~b, ~a};
endmodule