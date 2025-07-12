module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    // Explicit wire declarations
    wire [2:0] not_a;
    wire [2:0] not_b;
    
    // Bitwise OR of a and b
    assign out_or_bitwise = a | b;

    // Optimized logical OR - combines the two reduction operations
    assign out_or_logical = |(a | b);

    // NOT operations
    assign not_a = ~a;
    assign not_b = ~b;
    
    // Concatenated NOT outputs
    assign out_not = {not_b, not_a};

endmodule