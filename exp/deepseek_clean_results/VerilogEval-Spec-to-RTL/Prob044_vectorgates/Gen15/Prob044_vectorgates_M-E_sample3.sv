module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Shared computation: bitwise OR used for both bitwise and logical outputs
    assign out_or_bitwise = a | b;
    
    // Logical OR derived from bitwise OR result
    assign out_or_logical = |out_or_bitwise;
    
    // Concatenated NOT operations with optimal bit ordering
    assign out_not = {~b, ~a};
endmodule