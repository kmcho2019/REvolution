module TopModule(
    input a,
    input b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);

always @(*) begin
    out_and = a && b;
    out_or = a || b;
    out_xor = a ^ b;
    out_nand = ~(a && b);
    out_nor = ~(a || b);
    out_xnor = ~(a ^ b);
    out_anotb = a && ~b;
end

endmodule