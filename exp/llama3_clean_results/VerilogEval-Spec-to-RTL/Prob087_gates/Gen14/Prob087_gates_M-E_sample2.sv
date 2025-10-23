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

    // Define the LUT to store the output values
    logic [7:0] lut[2:0];

    // Initialize the LUT with the precomputed output values
    initial begin
        lut[0] = 8'b0000_0000; // a = 0, b = 0
        lut[1] = 8'b0111_0110; // a = 0, b = 1
        lut[2] = 8'b0111_0110; // a = 1, b = 0
        lut[3] = 8'b0111_0110; // a = 1, b = 1
    end

    // Retrieve the output values from the LUT based on the current input values
    assign out_and  = lut[{a, b}][0];
    assign out_or   = lut[{a, b}][1];
    assign out_xor  = lut[{a, b}][2];
    assign out_nand = lut[{a, b}][3];
    assign out_nor  = lut[{a, b}][4];
    assign out_xnor = lut[{a, b}][5];
    assign out_anotb = lut[{a, b}][6];

endmodule