module TopModule(
    input  logic a,
    input  logic b,
    output logic out_and,
    output logic out_or,
    output logic out_xor,
    output logic out_nand,
    output logic out_nor,
    output logic out_xnor,
    output logic out_anotb
);

    logic ab_xor;
    logic ab_and;

    assign ab_xor = a ^ b;
    assign ab_and = a && b;

    assign out_and = ab_and;
    assign out_or = a || b;
    assign out_xor = ab_xor;
    assign out_nand = ~(ab_and);
    assign out_nor = ~(a || b);
    assign out_xnor = ~(ab_xor);
    assign out_anotb = a && ~b;

endmodule