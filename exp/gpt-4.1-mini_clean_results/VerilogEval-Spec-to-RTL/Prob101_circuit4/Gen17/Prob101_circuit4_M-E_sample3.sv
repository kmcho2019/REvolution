module NandGate (
    input wire x,
    input wire y,
    output wire z
);
    assign z = ~(x & y);
endmodule

module NotGate (
    input wire in,
    output wire out
);
    // NOT using NAND with tied inputs
    NandGate nand_inv (
        .x(in),
        .y(in),
        .z(out)
    );
endmodule

module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire q
);
    wire not_b;
    wire not_c;
    wire and_nots;
    wire not_and;

    // Invert b and c
    NotGate nb (.in(b), .out(not_b));
    NotGate nc (.in(c), .out(not_c));

    // NAND equivalent of AND of inverted b and c (i.e. NAND of not_b and not_c)
    NandGate nand_and_nots (
        .x(not_b),
        .y(not_c),
        .z(and_nots)
    );

    // Invert the nand_and_nots to get q
    // This final inversion is a NOT implemented as NAND with tied inputs
    NotGate final_not (
        .in(and_nots),
        .out(q)
    );
endmodule