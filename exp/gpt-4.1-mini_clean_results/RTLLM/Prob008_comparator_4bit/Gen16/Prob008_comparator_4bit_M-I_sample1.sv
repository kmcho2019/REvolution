module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Borrow generate and propagate
    wire [3:0] g = (~A) & B;      // borrow generated if A[i] < B[i]
    wire [3:0] p = ~(A ^ B);      // borrow propagated if A[i] == B[i]

    // Shared propagate signals to reduce gate count
    wire p3p2 = p[3] & p[2];
    wire p3p2p1 = p3p2 & p[1];

    // Borrow out calculation with minimized logic
    wire borrow_out = g[3] | (p[3] & g[2]) | (p3p2 & g[1]) | (p3p2p1 & g[0]);

    // Equality detection: all bits equal using single 4-input AND of XNOR
    wire equal_bits = (p == 4'b1111);

    // Mutually exclusive outputs
    assign A_less    = borrow_out;
    assign A_equal   = equal_bits;
    assign A_greater = ~(borrow_out | equal_bits);

endmodule