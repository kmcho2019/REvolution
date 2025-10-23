// Improved TopModule with integrated gate logic
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

    // Directly implement the logic within the TopModule
    assign out_and = a && b;
    assign out_or = a || b;
    assign out_xor = a ^ b;
    assign out_nand = ~(a && b);
    assign out_nor = ~(a || b);
    assign out_xnor = (a && b) || (~a && ~b); // Alternative implementation for XNOR
    assign out_anotb = a && ~b;

endmodule