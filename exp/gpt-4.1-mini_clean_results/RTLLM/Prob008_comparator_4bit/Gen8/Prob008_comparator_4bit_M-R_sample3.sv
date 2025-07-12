module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Bitwise equality using direct XNOR (synthesizes to xnor gates)
    wire [3:0] eq_bit = ~(A ^ B); // Equivalent to A XNOR B

    // Function to compute borrow out given generate and propagate signals
    // Implements borrow lookahead chain: borrow_out = g3 + p3*g2 + p3*p2*g1 + p3*p2*p1*g0
    function automatic borrow_out_func;
        input [3:0] g;
        input [3:0] p;
        begin
            borrow_out_func = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
        end
    endfunction

    // Borrow generate: g[i] = (~A[i]) & B[i]
    wire [3:0] g = (~A) & B;

    // Borrow propagate: p[i] = eq_bit[i] (bit equality means propagate borrow)
    wire [3:0] p = eq_bit;

    // Calculate borrow out (A_less)
    wire borrow_out = borrow_out_func(g, p);

    // Calculate overall equality as AND of all bit equalities (balanced style)
    wire A_equal = &eq_bit;

    // Assign outputs
    assign A_less    = borrow_out;
    assign A_equal   = A_equal;
    assign A_greater = ~(borrow_out | A_equal);

endmodule