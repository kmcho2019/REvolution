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

    // Define LUTs for each logic gate
    logic [1:0] and_lut[1:0];
    logic [1:0] or_lut[1:0];
    logic [1:0] xor_lut[1:0];
    logic [1:0] nand_lut[1:0];
    logic [1:0] nor_lut[1:0];
    logic [1:0] xnor_lut[1:0];
    logic [1:0] andnot_lut[1:0];

    // Initialize LUTs with output values for all possible input combinations
    initial begin
        and_lut[0] = 2'b00; and_lut[1] = 2'b01; and_lut[2] = 2'b00; and_lut[3] = 2'b11;
        or_lut[0] = 2'b00; or_lut[1] = 2'b11; or_lut[2] = 2'b11; or_lut[3] = 2'b11;
        xor_lut[0] = 2'b00; xor_lut[1] = 2'b11; xor_lut[2] = 2'b11; xor_lut[3] = 2'b00;
        nand_lut[0] = 2'b11; nand_lut[1] = 2'b10; nand_lut[2] = 2'b11; nand_lut[3] = 2'b00;
        nor_lut[0] = 2'b11; nor_lut[1] = 2'b00; nor_lut[2] = 2'b00; nor_lut[3] = 2'b00;
        xnor_lut[0] = 2'b11; xnor_lut[1] = 2'b00; xnor_lut[2] = 2'b00; xnor_lut[3] = 2'b11;
        andnot_lut[0] = 2'b00; andnot_lut[1] = 2'b10; andnot_lut[2] = 2'b00; andnot_lut[3] = 2'b00;
    end

    // Use inputs 'a' and 'b' to index into LUTs and retrieve output values
    assign out_and = and_lut[{a, b}];
    assign out_or = or_lut[{a, b}];
    assign out_xor = xor_lut[{a, b}];
    assign out_nand = nand_lut[{a, b}];
    assign out_nor = nor_lut[{a, b}];
    assign out_xnor = xnor_lut[{a, b}];
    assign out_anotb = andnot_lut[{a, b}];

endmodule