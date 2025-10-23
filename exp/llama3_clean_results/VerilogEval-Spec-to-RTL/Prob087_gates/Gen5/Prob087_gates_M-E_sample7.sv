module TopModule(
    input a,
    input b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);

    // Define the lookup table
    reg [7:0] lut [3:0];
    initial begin
        // Initialize the LUT with pre-computed values
        lut[0] = 8'b00000000; // a=0, b=0
        lut[1] = 8'b00010111; // a=0, b=1
        lut[2] = 8'b00010111; // a=1, b=0
        lut[3] = 8'b11101101; // a=1, b=1
    end

    // Use the input values to index into the LUT
    reg [1:0] index;
    assign index = {a, b};

    // Assign the output values from the LUT
    assign {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = lut[index];

endmodule