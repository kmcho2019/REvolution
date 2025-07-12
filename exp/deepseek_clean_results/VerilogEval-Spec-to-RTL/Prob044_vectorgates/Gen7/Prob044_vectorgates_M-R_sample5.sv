module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Bitwise OR operation
    assign out_or_bitwise = a | b;
    
    // Logical OR operation (true if any bit in a or b is 1)
    assign out_or_logical = |a || |b;
    
    // NOT operations concatenated
    // Upper 3 bits: ~b, Lower 3 bits: ~a
    assign out_not = {~b, ~a};
endmodule