module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Bitwise OR (direct implementation)
    assign out_or_bitwise = a | b;
    
    // Logical OR (any bit set in either input)
    assign out_or_logical = (|a) || (|b);
    
    // NOT operations concatenated (b in upper bits)
    assign out_not = {~b, ~a};
endmodule