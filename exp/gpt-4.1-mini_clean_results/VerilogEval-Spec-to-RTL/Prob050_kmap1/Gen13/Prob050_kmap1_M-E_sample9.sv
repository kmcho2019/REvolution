// Basic 2-input NAND gate module
module NAND2 (
    input  x,
    input  y,
    output z
);
    assign z = ~(x & y);
endmodule

// Basic inverter module
module INV (
    input  x,
    output z
);
    assign z = ~x;
endmodule

// TopModule implements out = a + b + c using NAND and INV gates:
// Using De Morgan's law: out = ~(~a & ~b & ~c)
module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    wire na, nb, nc;    // inverted inputs
    wire nand_ab, nand_abc; // intermediate NAND outputs

    INV inv_a (.x(a), .z(na));
    INV inv_b (.x(b), .z(nb));
    INV inv_c (.x(c), .z(nc));

    // nand_ab = ~(na & nb)
    NAND2 nand2_1 (.x(na), .y(nb), .z(nand_ab));
    // out = ~(nand_ab & nc) = ~(~(na&nb) & nc) = ~(~a&~b&~c)
    NAND2 nand2_2 (.x(nand_ab), .y(nc), .z(out));
endmodule