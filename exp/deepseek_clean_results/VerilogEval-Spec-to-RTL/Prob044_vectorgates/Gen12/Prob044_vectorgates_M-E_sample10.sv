module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Internal signals for NOT operations
    wire [2:0] not_a = ~a;
    wire [2:0] not_b = ~b;
    
    // Compute all outputs in parallel
    always @(*) begin
        // Bitwise OR (direct computation)
        out_or_bitwise = a | b;
        
        // Logical OR (derived from bitwise OR)
        out_or_logical = |out_or_bitwise;
        
        // NOT outputs with proper concatenation
        out_not = {not_b, not_a};
    end
endmodule