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

    // Define a lookup table (LUT) to store output values for all possible input combinations
    logic [7:0] lut [1:0][1:0];

    // Initialize the LUT with output values for all possible input combinations
    initial begin
        lut[0][0] = 8'b00000000; // a = 0, b = 0
        lut[0][1] = 8'b00010001; // a = 0, b = 1
        lut[1][0] = 8'b00010001; // a = 1, b = 0
        lut[1][1] = 8'b10110110; // a = 1, b = 1
    end

    // Use inputs 'a' and 'b' to index into the LUT and retrieve output values
    assign {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = lut[a][b];

endmodule