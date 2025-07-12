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

    // Using always_comb blocks to encapsulate the logic
    always_comb begin
        out_and = a && b;
        out_or = a || b;
        out_xor = a ^ b;
        out_nand = ~(a && b);
        out_nor = ~(a || b);
        out_xnor = ~(a ^ b);
        out_anotb = a && ~b;
    end

    // Alternatively, we could have separate always_comb blocks for each operation
    // always_comb out_and = a && b;
    // always_comb out_or = a || b;
    // always_comb out_xor = a ^ b;
    // always_comb out_nand = ~(a && b);
    // always_comb out_nor = ~(a || b);
    // always_comb out_xnor = ~(a ^ b);
    // always_comb out_anotb = a && ~b;

endmodule