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

    // Create a 4x7 ROM (2 address bits, 7 data bits)
    reg [6:0] rom [0:3];
    
    // Initialize ROM with all possible output combinations
    initial begin
        // Format: [anotb, xnor, nor, nand, xor, or, and]
        rom[2'b00] = 7'b0001110; // a=0, b=0
        rom[2'b01] = 7'b0010101; // a=0, b=1
        rom[2'b10] = 7'b1101000; // a=1, b=0
        rom[2'b11] = 7'b0110011; // a=1, b=1
    end
    
    // Use input combination as address
    wire [1:0] addr = {a, b};
    wire [6:0] rom_out = rom[addr];
    
    // Assign outputs from ROM
    assign {out_anotb, out_xnor, out_nor, out_nand, out_xor, out_or, out_and} = rom_out;

endmodule