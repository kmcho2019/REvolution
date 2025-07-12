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

// Internal wires for sum (XOR)
wire nand_ab;      // NAND of a and b
wire nand_a_nand;  // NAND of a and nand_ab
wire nand_b_nand;  // NAND of b and nand_ab

// Sum implementation (XOR) using 3 NAND gates
NAND2 nand1 (.x(a), .y(b), .z(nand_ab));
NAND2 nand2 (.x(a), .y(nand_ab), .z(nand_a_nand));
NAND2 nand3 (.x(b), .y(nand_ab), .z(nand_b_nand));
NAND2 nand4 (.x(nand_a_nand), .y(nand_b_nand), .z(sum));

// Carry-out (AND) implementation using 2 NAND gates:
// cout = a & b = NAND(NAND(a,b), NAND(a,b))
wire nand_ab_inv;
NAND2 nand5 (.x(nand_ab), .y(nand_ab), .z(cout));

endmodule