module TopModule(
    input  [3:0] x,
    output       f
);

    reg [0:0] rom [0:15]; // ROM with 16 entries, each 1 bit wide

    // Initialize the ROM with the output values of f
    initial begin
        rom[0]  = 1'b1; // x = 0000
        rom[1]  = 1'b0; // x = 0001
        rom[2]  = 1'b0; // x = 0010
        rom[3]  = 1'b1; // x = 0011
        rom[4]  = 1'b0; // x = 0100
        rom[5]  = 1'b0; // x = 0101
        rom[6]  = 1'b0; // x = 0110
        rom[7]  = 1'b0; // x = 0111
        rom[8]  = 1'b1; // x = 1000
        rom[9]  = 1'b1; // x = 1001
        rom[10] = 1'b1; // x = 1010
        rom[11] = 1'b0; // x = 1011
        rom[12] = 1'b1; // x = 1100
        rom[13] = 1'b1; // x = 1101
        rom[14] = 1'b0; // x = 1110
        rom[15] = 1'b1; // x = 1111
    end

    // Use the input x as an address to access the output value from the ROM
    assign f = rom[x];

endmodule