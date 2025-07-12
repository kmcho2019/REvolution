module NAND2 (
    input  a,
    input  b,
    output y
);
    nand (y, a, b);
endmodule

module TopModule (
    input  x,
    input  y,
    output z
);
    wire nand_b_b;
    wire nand_a_a;
    wire xor_part1;
    wire xor_part2;
    wire xor_out;
    wire and_nand_out;
    wire and_out;

    // nand_b_b = ~(y & y) = ~y
    NAND2 u_nand_b_b (
        .a(y),
        .b(y),
        .y(nand_b_b)
    );

    // nand_a_a = ~(x & x) = ~x
    NAND2 u_nand_a_a (
        .a(x),
        .b(x),
        .y(nand_a_a)
    );

    // xor_part1 = ~(x & nand_b_b) = x NAND (~y)
    NAND2 u_xor_part1 (
        .a(x),
        .b(nand_b_b),
        .y(xor_part1)
    );

    // xor_part2 = ~(nand_a_a & y) = (~x) NAND y
    NAND2 u_xor_part2 (
        .a(nand_a_a),
        .b(y),
        .y(xor_part2)
    );

    // xor_out = ~(xor_part1 & xor_part2) = XOR output
    NAND2 u_xor_out (
        .a(xor_part1),
        .b(xor_part2),
        .y(xor_out)
    );

    // and_nand_out = ~(xor_out & x)
    NAND2 u_and_nand_out (
        .a(xor_out),
        .b(x),
        .y(and_nand_out)
    );

    // and_out = ~(and_nand_out & and_nand_out) = output AND after double NAND inversion
    NAND2 u_and_out (
        .a(and_nand_out),
        .b(and_nand_out),
        .y(z)
    );

endmodule