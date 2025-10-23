module TopModule(
    input x,
    input y,
    output z
);
    wire x_nand_y, x_nand_x, y_nand_y;
    wire xor_part;
    wire and_part;

    // NAND gate definition: NAND(a,b) = ~(a & b)
    // XOR implementation using NANDs:
    // xor = (x nand (x nand y)) nand (y nand (x nand y))
    assign x_nand_y = ~(x & y);
    assign x_nand_x = ~(x & x); // NOT x
    assign y_nand_y = ~(y & y); // NOT y

    // Implement XOR as (x NAND (x NAND y)) NAND (y NAND (x NAND y))
    wire a1 = ~(x & x_nand_y);
    wire a2 = ~(y & x_nand_y);
    assign xor_part = ~(a1 & a2);

    // AND using NAND: AND(a,b) = NAND(NAND(a,b), NAND(a,b))
    assign and_part = ~(~(xor_part & x) & ~(xor_part & x));

    assign z = and_part;

endmodule