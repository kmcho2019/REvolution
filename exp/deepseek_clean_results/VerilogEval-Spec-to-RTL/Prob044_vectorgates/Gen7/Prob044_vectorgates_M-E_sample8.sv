module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Unified processing core
    always @(*) begin
        // Bitwise OR (parallel computation)
        out_or_bitwise = a | b;
        
        // Logical OR derived from bitwise result
        out_or_logical = |out_or_bitwise;
        
        // Combined NOT operation with optimal concatenation
        out_not = {~b, ~a};
    end
endmodule