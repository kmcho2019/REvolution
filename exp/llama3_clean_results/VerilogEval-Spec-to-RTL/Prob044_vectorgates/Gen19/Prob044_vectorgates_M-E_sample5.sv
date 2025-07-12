// Top-level module
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Perform all operations in parallel
    always_comb begin
        // Bitwise-OR operation
        out_or_bitwise = a | b;
        
        // Logical-OR operation
        out_or_logical = (|a) || (|b);
        
        // NOT operation for a and b
        out_not[5:3] = ~b;
        out_not[2:0] = ~a;
    end

endmodule