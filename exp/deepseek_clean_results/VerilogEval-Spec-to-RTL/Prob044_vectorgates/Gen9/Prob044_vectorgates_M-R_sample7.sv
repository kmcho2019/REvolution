module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Bitwise OR using NOT-NOR optimization
    assign out_or_bitwise = ~(~a & ~b);
    
    // Logical OR as reduction of bitwise OR
    assign out_or_logical = |(a | b);
    
    // NOT operations concatenated as specified
    assign out_not = {~b, ~a};
endmodule