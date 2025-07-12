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

    // Define lookup tables for each logical operation
    logic and_lut[2:0];
    logic or_lut[2:0];
    logic xor_lut[2:0];
    logic nand_lut[2:0];
    logic nor_lut[2:0];
    logic xnor_lut[2:0];
    logic anotb_lut[2:0];

    // Initialize lookup tables with truth tables
    initial begin
        and_lut[0] = 0; and_lut[1] = 0; and_lut[2] = 0; and_lut[3] = 1;
        or_lut[0] = 0; or_lut[1] = 1; or_lut[2] = 1; or_lut[3] = 1;
        xor_lut[0] = 0; xor_lut[1] = 1; xor_lut[2] = 1; xor_lut[3] = 0;
        nand_lut[0] = 1; nand_lut[1] = 1; nand_lut[2] = 1; nand_lut[3] = 0;
        nor_lut[0] = 1; nor_lut[1] = 0; nor_lut[2] = 0; nor_lut[3] = 0;
        xnor_lut[0] = 1; xnor_lut[1] = 0; xnor_lut[2] = 0; xnor_lut[3] = 1;
        anotb_lut[0] = 0; anotb_lut[1] = 1; anotb_lut[2] = 0; anotb_lut[3] = 0;
    end

    // Use a centralized control unit to manage inputs and outputs
    always @(*) begin
        out_and = and_lut[{a, b}];
        out_or = or_lut[{a, b}];
        out_xor = xor_lut[{a, b}];
        out_nand = nand_lut[{a, b}];
        out_nor = nor_lut[{a, b}];
        out_xnor = xnor_lut[{a, b}];
        out_anotb = anotb_lut[{a, b}];
    end

endmodule