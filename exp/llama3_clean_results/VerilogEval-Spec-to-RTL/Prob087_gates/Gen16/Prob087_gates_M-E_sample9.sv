// Define the lookup table
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

    // Define the lookup table
    logic [7:0] lut [3:0];
    initial begin
        lut[0] = 8'b00000000; // a = 0, b = 0
        lut[1] = 8'b01011010; // a = 0, b = 1
        lut[2] = 8'b01011010; // a = 1, b = 0
        lut[3] = 8'b00110101; // a = 1, b = 1
    end

    // Use the input values to index into the LUT
    logic [1:0] index;
    assign index = {a, b};

    // Assign the retrieved output values to the output ports
    assign {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb, } = lut[index];

endmodule