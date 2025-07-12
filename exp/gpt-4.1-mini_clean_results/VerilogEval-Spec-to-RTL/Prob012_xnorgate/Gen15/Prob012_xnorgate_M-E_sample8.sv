module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    wire not_a, not_b;
    wire a_and_b;
    wire nota_and_notb;
    
    // Invert inputs
    assign not_a = ~a;
    assign not_b = ~b;

    // AND gates for (a & b) and (~a & ~b)
    assign a_and_b = a & b;
    assign nota_and_notb = not_a & not_b;

    // OR gate to combine the two AND terms, resulting in XNOR
    assign out = a_and_b | nota_and_notb;

endmodule