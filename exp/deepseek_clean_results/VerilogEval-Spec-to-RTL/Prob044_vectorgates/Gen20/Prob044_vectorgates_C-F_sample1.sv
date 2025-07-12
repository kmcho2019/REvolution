module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Bitwise OR operation (3-bit)
    assign out_or_bitwise = a | b;
    
    // Optimized Logical OR operation (1-bit)
    // More efficient than (|a) || (|b) - uses single reduction OR
    assign out_or_logical = |(a | b);
    
    // NOT operations with concatenation
    // b's inverse in upper 3 bits [5:3], a's inverse in lower 3 bits [2:0]
    assign out_not = {~b, ~a};
endmodule