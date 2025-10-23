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

    // Input combination decoder
    wire [1:0] sel = {a, b};

    // AND gate implementation
    assign out_and = (sel == 2'b11) ? 1'b1 : 1'b0;

    // OR gate implementation
    assign out_or = (sel != 2'b00) ? 1'b1 : 1'b0;

    // XOR gate implementation
    assign out_xor = (sel == 2'b01 || sel == 2'b10) ? 1'b1 : 1'b0;

    // NAND gate implementation
    assign out_nand = (sel != 2'b11) ? 1'b1 : 1'b0;

    // NOR gate implementation
    assign out_nor = (sel == 2'b00) ? 1'b1 : 1'b0;

    // XNOR gate implementation
    assign out_xnor = (sel == 2'b00 || sel == 2'b11) ? 1'b1 : 1'b0;

    // A AND-NOT B implementation
    assign out_anotb = (sel == 2'b10) ? 1'b1 : 1'b0;

endmodule