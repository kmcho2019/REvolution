module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] g; // borrow generate signals
    wire [3:0] p; // borrow propagate signals
    wire borrow_out;
    wire equal_bits;

    genvar i;

    // Generate and propagate signals per bit using standard borrow logic:
    // g[i] = (~A[i] & B[i])
    // p[i] = (~(A[i] ^ B[i]))
    generate
        for (i = 0; i < 4; i = i + 1) begin : GEN_PROP
            assign g[i] = (~A[i]) & B[i];
            assign p[i] = ~(A[i] ^ B[i]);
        end
    endgenerate

    // Borrow lookahead logic to compute borrow_out without ripple:
    // borrow_out = g[3] | (p[3]&g[2]) | (p[3]&p[2]&g[1]) | (p[3]&p[2]&p[1]&g[0])
    assign borrow_out = g[3] 
                      | (p[3] & g[2]) 
                      | (p[3] & p[2] & g[1]) 
                      | (p[3] & p[2] & p[1] & g[0]);

    // Equality check: all bits equal if all p[i] == 1 (since p[i] = XNOR(A[i],B[i]))
    assign equal_bits = &p;

    // Outputs: mutually exclusive
    assign A_less    = borrow_out;
    assign A_equal   = equal_bits;
    assign A_greater = ~(borrow_out | equal_bits);

endmodule