module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Bitwise OR of inputs
    assign out_or_bitwise = a | b;
    
    // Logical OR (reduction of bitwise OR)
    assign out_or_logical = |(a | b);
    
    // NOT operations concatenated with b's inverse in upper bits
    assign out_not = {~b, ~a};
endmodule