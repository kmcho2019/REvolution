module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Compute borrow generate and propagate vectors:
    // g[i] = ~A[i] & B[i]
    wire [3:0] g = (~A) & B;
    // p[i] = ~(A[i] ^ B[i])  equivalently p = ~(A ^ B)
    wire [3:0] p = ~(A ^ B);

    // Calculate borrow_out using borrow lookahead formula:
    // borrow_out = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0])
    wire borrow_out;
    assign borrow_out = g[3] 
                      | (p[3] & g[2]) 
                      | (p[3] & p[2] & g[1]) 
                      | (p[3] & p[2] & p[1] & g[0]);

    // Equality is when all bits match (all propagate bits are 1)
    wire equal_bits = &p; // reduction AND on p (all bits 1 means equality)

    assign A_less    = borrow_out;
    assign A_equal   = equal_bits;
    assign A_greater = ~(borrow_out | equal_bits);

endmodule