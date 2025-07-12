module TopModule (
    input  a, b,
    output out_and, out_or, out_xor,
    output out_nand, out_nor, out_xnor,
    output out_anotb
);

    always @(*) begin
        out_and = a & b;
        out_or = a | b;
        out_xor = a ^ b;
        out_nand = ~(a & b);
        out_nor = ~(a | b);
        out_xnor = ~(a ^ b);
        out_anotb = a & ~b;
    end

endmodule