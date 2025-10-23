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

// NAND gate outputs for sum (XOR) calculation
wire nand_ab;       // NAND of a and b
wire nand_a_nandab; // NAND of a and nand_ab
wire nand_b_nandab; // NAND of b and nand_ab

// Half Adder Sum = a XOR b implemented using NAND gates
NAND2 nand1 (.x(a), .y(b),          .z(nand_ab));
NAND2 nand2 (.x(a), .y(nand_ab),    .z(nand_a_nandab));
NAND2 nand3 (.x(b), .y(nand_ab),    .z(nand_b_nandab));
NAND2 nand4 (.x(nand_a_nandab), .y(nand_b_nandab), .z(sum));

// Carry out = a AND b = NAND(NAND(a,b), NAND(a,b))
NAND2 nand5 (.x(nand_ab), .y(nand_ab), .z(cout));

endmodule