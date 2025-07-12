// Define the LUT for the logic operations
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

    // LUT to store output values for all possible input combinations
    logic [3:0] lut_and = 4'b0001;  // AND
    logic [3:0] lut_or =  4'b0011;  // OR
    logic [3:0] lut_xor = 4'b0110;  // XOR
    logic [3:0] lut_nand = 4'b1110; // NAND
    logic [3:0] lut_nor =  4'b1000; // NOR
    logic [3:0] lut_xnor = 4'b1001; // XNOR
    logic [3:0] lut_anotb = 4'b0100; // ANDNOT

    // Use the inputs (a and b) as an address to access the corresponding output value from the LUT
    assign out_and  = lut_and[{a, b}];
    assign out_or   = lut_or [{a, b}];
    assign out_xor  = lut_xor[{a, b}];
    assign out_nand = lut_nand[{a, b}];
    assign out_nor  = lut_nor [{a, b}];
    assign out_xnor = lut_xnor[{a, b}];
    assign out_anotb = lut_anotb[{a, b}];

endmodule