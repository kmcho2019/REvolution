module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Parallel processing implementation
    always @(*) begin
        // Bitwise OR (3-bit)
        out_or_bitwise = a | b;
        
        // Logical OR derived from bitwise result
        out_or_logical = |out_or_bitwise;
        
        // Concatenated NOT operations (6-bit)
        // b's inverse in upper 3 bits, a's in lower
        out_not = {~b, ~a};
    end
endmodule