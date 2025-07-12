module TopModule (
    input [2:0] a,
    output [15:0] q
);

// ROM content organized by bits (16 words of 8 bits each)
wire [7:0] rom [0:15];
assign rom[0]  = 8'b00110010; // bits for a=0 (1232)
assign rom[1]  = 8'b11001001;
assign rom[2]  = 8'b11100000; // bits for a=1 (aee0)
assign rom[3]  = 8'b01110111;
assign rom[4]  = 8'b00101101; // bits for a=2 (27d4)
assign rom[5]  = 8'b11101000;
assign rom[6]  = 8'b01110000; // bits for a=3 (5a0e)
assign rom[7]  = 8'b10110100;
assign rom[8]  = 8'b01100100; // bits for a=4 (2066)
assign rom[9]  = 8'b00000100;
assign rom[10] = 8'b01110011; // bits for a=5 (64ce)
assign rom[11] = 8'b00100110;
assign rom[12] = 8'b01100100; // bits for a=6 (c526)
assign rom[13] = 8'b10100011;
assign rom[14] = 8'b10011000; // bits for a=7 (2f19)
assign rom[15] = 8'b11110100;

// Address calculation
wire [3:0] addr_base = {a, 1'b0}; // Multiply by 2 since each value uses 2 ROM words
wire [3:0] addr_msb = addr_base;
wire [3:0] addr_lsb = addr_base + 1;

// Output assembly
assign q = {rom[addr_msb], rom[addr_lsb]};

endmodule