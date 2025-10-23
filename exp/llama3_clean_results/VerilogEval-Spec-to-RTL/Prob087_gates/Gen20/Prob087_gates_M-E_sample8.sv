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

    // Initialize the lookup table with all possible outcomes
    logic [6:0] lut [1:0][1:0];

    initial begin
        // 00
        lut[0][0] = 7'b0000000;
        // 01
        lut[0][1] = 7'b0101011;
        // 10
        lut[1][0] = 7'b0101011;
        // 11
        lut[1][1] = 7'b1110001;
    end

    // Assign outputs based on the lookup table
    always @(a or b) begin
        {out_anotb, out_xnor, out_nor, out_nand, out_xor, out_or, out_and} = lut[a][b];
    end

endmodule