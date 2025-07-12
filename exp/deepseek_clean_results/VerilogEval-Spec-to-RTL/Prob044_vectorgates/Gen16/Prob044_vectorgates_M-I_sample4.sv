module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Bitwise OR (3-bit)
    assign out_or_bitwise = a | b;
    
    // Logical OR (reduction OR of bitwise OR)
    assign out_or_logical = |(a | b);
    
    // NOT operations (b in upper 3 bits, a in lower 3 bits)
    assign out_not = {~b, ~a};
endmodule