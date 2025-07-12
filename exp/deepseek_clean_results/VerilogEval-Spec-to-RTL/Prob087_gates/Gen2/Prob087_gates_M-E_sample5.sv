module TopModule (
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

    // Combine inputs to form 2-bit selector
    wire [1:0] sel = {a, b};

    // Pre-compute all output patterns for each input combination
    reg [6:0] lut [0:3];
    
    initial begin
        // Truth table implementation:
        // Index: {a,b}
        // Outputs: [and, or, xor, nand, nor, xnor, anotb]
        lut[2'b00] = 7'b0001101;
        lut[2'b01] = 7'b0011010;
        lut[2'b10] = 7'b0110100;
        lut[2'b11] = 7'b1100010;
    end

    // Assign outputs from LUT
    assign {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = lut[sel];

endmodule