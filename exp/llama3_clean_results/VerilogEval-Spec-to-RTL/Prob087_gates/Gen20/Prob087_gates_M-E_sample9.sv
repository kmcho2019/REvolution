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

    // Define a multiplexed gate array
    logic [7:0] outputs;
    always_comb begin
        outputs[0] = a & b;  // AND
        outputs[1] = a | b;  // OR
        outputs[2] = a ^ b;  // XOR
        outputs[3] = ~(a & b);  // NAND
        outputs[4] = ~(a | b);  // NOR
        outputs[5] = ~(a ^ b);  // XNOR
        outputs[6] = a & ~b;  // AND-NOT
        outputs[7] = 1'b0;  // Unused
    end

    // Use a multiplexer to select the correct output
    always_comb begin
        out_and = outputs[0];
        out_or = outputs[1];
        out_xor = outputs[2];
        out_nand = outputs[3];
        out_nor = outputs[4];
        out_xnor = outputs[5];
        out_anotb = outputs[6];
    end

endmodule