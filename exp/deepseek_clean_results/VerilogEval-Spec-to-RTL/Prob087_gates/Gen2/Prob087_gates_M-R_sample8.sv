module TopModule (
    input a,
    input b,
    output reg out_and,
    output reg out_or,
    output reg out_xor,
    output reg out_nand,
    output reg out_nor,
    output reg out_xnor,
    output reg out_anotb
);

    always @(*) begin
        // AND gate
        out_and = a & b;

        // OR gate
        out_or = a | b;

        // XOR gate
        out_xor = a ^ b;

        // NAND gate
        out_nand = ~(a & b);

        // NOR gate
        out_nor = ~(a | b);

        // XNOR gate
        out_xnor = ~(a ^ b);

        // A AND-NOT B gate
        out_anotb = a & (~b);
    end

endmodule