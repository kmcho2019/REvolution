module NorGate(
    input x,
    input y,
    output z
);
    nor nor_inst(z, x, y);
endmodule

module NandGate(
    input x,
    input y,
    output z
);
    nand nand_inst(z, x, y);
endmodule

module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);
    wire nb, nc;
    NorGate nor1(.x(b), .y(b), .z(nb)); // nb = NOT b
    NorGate nor2(.x(c), .y(c), .z(nc)); // nc = NOT c
    NandGate nand1(.x(nb), .y(nc), .z(q)); // q = NAND(nb, nc) = OR(b, c)
endmodule