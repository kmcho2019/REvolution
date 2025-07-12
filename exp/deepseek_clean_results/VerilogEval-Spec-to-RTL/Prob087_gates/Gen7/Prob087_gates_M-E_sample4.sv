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

    // Concatenate inputs to form 2-bit address
    wire [1:0] addr = {a, b};

    // Truth table for all outputs (7 bits wide)
    reg [6:0] lut [0:3];
    
    initial begin
        // addr[1] = a, addr[0] = b
        // Output order: [anotb, xnor, nor, nand, xor, or, and]
        lut[0] = 7'b0001110; // a=0, b=0
        lut[1] = 7'b0010101; // a=0, b=1
        lut[2] = 7'b1101000; // a=1, b=0
        lut[3] = 7'b0110011; // a=1, b=1
    end

    // Assign outputs from LUT
    assign {out_anotb, out_xnor, out_nor, out_nand, out_xor, out_or, out_and} = lut[addr];

endmodule