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

    // Define the look-up tables for each gate type
    logic [1:0] and_lut [3:0] = '{4'b0001, 4'b0010, 4'b0100, 4'b1000};
    logic [1:0] or_lut  [3:0] = '{4'b0011, 4'b0111, 4'b1011, 4'b1111};
    logic [1:0] xor_lut [3:0] = '{4'b0110, 4'b1010, 4'b1100, 4'b0000};
    logic [1:0] nand_lut[3:0] = '{4'b1110, 4'b1101, 4'b1011, 4'b0111};
    logic [1:0] nor_lut [3:0] = '{4'b1000, 4'b0100, 4'b0010, 4'b0001};
    logic [1:0] xnor_lut[3:0] = '{4'b1001, 4'b0101, 4'b0011, 4'b0000};
    logic [1:0] anotb_lut[3:0] = '{4'b1000, 4'b0000, 4'b0100, 4'b0000};

    // Create a 2-bit index from the input signals
    logic [1:0] index = {a, b};

    // Use the index to retrieve the output from the corresponding LUT
    always_comb begin
        out_and  = and_lut[index][0];
        out_or   = or_lut[index][0];
        out_xor  = xor_lut[index][0];
        out_nand = nand_lut[index][0];
        out_nor  = nor_lut[index][0];
        out_xnor = xnor_lut[index][0];
        out_anotb = anotb_lut[index][0];
    end

endmodule