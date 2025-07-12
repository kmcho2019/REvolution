module NorGate (
    input wire x,
    input wire y,
    output wire z
);
    assign z = ~(x | y);
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    wire na, nb, or_out;

    // Invert inputs using NOR gates with tied inputs (NOR(x,x) = NOT x)
    NorGate nor_a_inv (.x(a), .y(a), .z(na));
    NorGate nor_b_inv (.x(b), .y(b), .z(nb));
    // OR of inverted inputs (na OR nb) inverted again by NOR to form AND
    NorGate nor_and (.x(na), .y(nb), .z(q));
endmodule