module NorGate (
    input wire x,
    input wire y,
    output wire z
);
    assign z = ~(x | y);
endmodule

module AndGate (
    input  wire a,
    input  wire b,
    output wire y
);
    wire na, nb;

    // Invert inputs using NOR gates with tied inputs (NOR(x,x) = NOT x)
    NorGate nor_a_inv (.x(a), .y(a), .z(na));
    NorGate nor_b_inv (.x(b), .y(b), .z(nb));
    // NOR the inverted inputs to get AND
    NorGate nor_and (.x(na), .y(nb), .z(y));
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    AndGate and_inst (
        .a(a),
        .b(b),
        .y(q)
    );
endmodule