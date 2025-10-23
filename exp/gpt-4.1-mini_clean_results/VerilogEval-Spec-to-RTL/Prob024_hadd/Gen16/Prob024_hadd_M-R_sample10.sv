module NAND2 (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = ~(x & y);
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    output wire sum,
    output wire cout
);

wire nand_ab;
wire nand_a_nand_ab;
wire nand_b_nand_ab;

// Instantiate NAND gates structurally
NAND2 nand_gate1 (
    .x(a),
    .y(b),
    .z(nand_ab)
);

NAND2 nand_gate2 (
    .x(a),
    .y(nand_ab),
    .z(nand_a_nand_ab)
);

NAND2 nand_gate3 (
    .x(b),
    .y(nand_ab),
    .z(nand_b_nand_ab)
);

NAND2 nand_gate4 (
    .x(nand_a_nand_ab),
    .y(nand_b_nand_ab),
    .z(sum)
);

// For cout, reuse nand_ab and NAND it with itself to create AND
NAND2 nand_gate5 (
    .x(nand_ab),
    .y(nand_ab),
    .z(cout)
);

endmodule