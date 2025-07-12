module TopModule (
    input  a,
    input  b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);

    // Create 2-bit input selector
    wire [1:0] sel = {a, b};

    // AND truth table: 0 0 0 1
    assign out_and = (sel == 2'b11);

    // OR truth table: 0 1 1 1
    assign out_or = (sel != 2'b00);

    // XOR truth table: 0 1 1 0
    assign out_xor = (sel == 2'b01) || (sel == 2'b10);

    // NAND truth table: 1 1 1 0
    assign out_nand = (sel != 2'b11);

    // NOR truth table: 1 0 0 0
    assign out_nor = (sel == 2'b00);

    // XNOR truth table: 1 0 0 1
    assign out_xnor = (sel == 2'b00) || (sel == 2'b11);

    // A AND-NOT B truth table: 0 0 1 0
    assign out_anotb = (sel == 2'b10);

endmodule