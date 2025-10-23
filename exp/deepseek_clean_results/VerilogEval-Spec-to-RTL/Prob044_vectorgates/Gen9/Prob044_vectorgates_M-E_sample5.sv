module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Bitwise OR is direct
    assign out_or_bitwise = a | b;
    
    // Logical OR is reduction of bitwise OR (more efficient than separate reductions)
    assign out_or_logical = |out_or_bitwise;
    
    // NOT operations concatenated with b's inverse in upper bits
    assign out_not = {~b, ~a};
endmodule