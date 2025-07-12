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

    // 2-bit address formed from inputs
    wire [1:0] addr = {a, b};
    
    // 7-bit ROM output containing all logic function results
    reg [6:0] rom [0:3];
    
    // Initialize ROM with precomputed truth tables
    initial begin
        // Format: {anotb, xnor, nor, nand, xor, or, and}
        rom[0] = 7'b0_1_1_1_0_0_0; // a=0, b=0
        rom[1] = 7'b0_0_0_1_1_1_0; // a=0, b=1
        rom[2] = 7'b1_0_0_1_1_1_0; // a=1, b=0
        rom[3] = 7'b0_1_0_0_0_1_1; // a=1, b=1
    end
    
    // Output assignment from ROM
    wire [6:0] rom_out = rom[addr];
    assign {out_anotb, out_xnor, out_nor, out_nand, out_xor, out_or, out_and} = rom_out;

endmodule