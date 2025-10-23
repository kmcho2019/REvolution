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

    logic [7:0] lut[2:0];

    // Populate the LUT
    initial begin
        lut[0] = 8'b00000000; // a=0, b=0
        lut[1] = 8'b01010101; // a=0, b=1
        lut[2] = 8'b01010110; // a=1, b=0
        lut[3] = 8'b11101111; // a=1, b=1
    end

    // Index into the LUT using (a, b) and assign outputs
    assign {out_anotb, out_xnor, out_nor, out_nand, out_xor, out_or, out_and} = lut[{a, b}];

endmodule