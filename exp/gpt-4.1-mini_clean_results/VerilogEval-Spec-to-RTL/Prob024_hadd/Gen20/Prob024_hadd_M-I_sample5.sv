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

wire nand_ab;          // NAND of a and b
wire nand_a_nand_ab;   // NAND of a and nand_ab
wire nand_b_nand_ab;   // NAND of b and nand_ab

// sum = XOR implemented with 4 NAND gates
NAND2 nand_gate1 ( .x(a),        .y(b),        .z(nand_ab)          );
NAND2 nand_gate2 ( .x(a),        .y(nand_ab),  .z(nand_a_nand_ab)   );
NAND2 nand_gate3 ( .x(b),        .y(nand_ab),  .z(nand_b_nand_ab)   );
NAND2 nand_gate4 ( .x(nand_a_nand_ab), .y(nand_b_nand_ab), .z(sum) );

// cout = AND(a,b) = NAND(a,b) followed by inverter
// inverter implemented as NAND gate with tied inputs
NAND2 nand_gate5 ( .x(nand_ab), .y(nand_ab), .z(cout) );

endmodule