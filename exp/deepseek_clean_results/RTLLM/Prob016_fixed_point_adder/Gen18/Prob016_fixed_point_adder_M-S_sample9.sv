module fixed_point_adder #(
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c,
    output wire overflow
);

    // Perform direct two's complement addition
    wire [N-1:0] res = a + b;
    
    // Overflow occurs when:
    // 1. Both operands are positive and result is negative
    // 2. Both operands are negative and result is positive
    assign overflow = (~a[N-1] & ~b[N-1] & res[N-1]) | 
                     (a[N-1] & b[N-1] & ~res[N-1]);
    
    assign c = res;

endmodule