module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Bitwise OR (3-bit vector operation)
    assign out_or_bitwise = a | b;
    
    // Logical OR (single bit result)
    assign out_or_logical = |a || |b;
    
    // NOT operations with concatenation
    assign out_not = {~b, ~a};
endmodule