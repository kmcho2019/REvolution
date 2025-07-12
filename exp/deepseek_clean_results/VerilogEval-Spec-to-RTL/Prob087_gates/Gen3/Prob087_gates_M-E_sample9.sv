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

    // Input address encoding
    wire [1:0] addr = {a, b};

    // Output ROM implementation
    reg [6:0] rom [0:3];
    
    initial begin
        // addr[1] = a, addr[0] = b
        // Format: {out_anotb, out_xnor, out_nor, out_nand, out_xor, out_or, out_and}
        rom[2'b00] = 7'b0_1_1_1_0_0_0;  // a=0, b=0
        rom[2'b01] = 7'b0_0_0_1_1_1_0;   // a=0, b=1
        rom[2'b10] = 7'b1_0_0_1_1_1_0;   // a=1, b=0
        rom[2'b11] = 7'b0_1_0_0_0_1_1;   // a=1, b=1
    end

    // Output assignments
    assign {out_anotb, out_xnor, out_nor, out_nand, out_xor, out_or, out_and} = rom[addr];

endmodule