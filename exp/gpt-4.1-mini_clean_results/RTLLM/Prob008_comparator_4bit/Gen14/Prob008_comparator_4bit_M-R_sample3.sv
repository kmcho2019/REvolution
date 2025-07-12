module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] eq_bit;
    wire [3:0] g; // borrow generate signals
    wire [3:0] p; // borrow propagate signals
    wire [4:0] borrow; // borrow chain, borrow[0] = initial borrow_in = 0

    assign borrow[0] = 1'b0; // no initial borrow in subtraction

    // Compute per-bit equality with XNOR (A XNOR B)
    assign eq_bit = ~(A ^ B);

    // Generate and propagate for borrow logic:
    // g[i] = ~A[i] & B[i]
    // p[i] = eq_bit[i]
    assign g = (~A) & B;
    assign p = eq_bit;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : borrow_chain
            assign borrow[i+1] = g[i] | (p[i] & borrow[i]);
        end
    endgenerate

    // Overall equality if all bits equal (XNOR reduction)
    assign A_equal = &eq_bit;

    assign A_less = borrow[4];

    // Mutually exclusive: A_greater = !(A_less or A_equal)
    assign A_greater = ~(A_less | A_equal);

endmodule