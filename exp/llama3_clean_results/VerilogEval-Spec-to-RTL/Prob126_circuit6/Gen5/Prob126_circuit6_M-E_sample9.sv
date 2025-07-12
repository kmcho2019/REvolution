module TopModule(
    input [2:0] a,
    output [15:0] q
);

// Define the ROM contents
reg [15:0] rom[8];

initial begin
    rom[0] = 16'h1232; // For a = 3'b000
    rom[1] = 16'haee0; // For a = 3'b001
    rom[2] = 16'h27d4; // For a = 3'b010
    rom[3] = 16'h5a0e; // For a = 3'b011
    rom[4] = 16'h2066; // For a = 3'b100
    rom[5] = 16'h64ce; // For a = 3'b101
    rom[6] = 16'hc526; // For a = 3'b110
    rom[7] = 16'h2f19; // For a = 3'b111
end

// Use the input a as an address to fetch the output from the ROM
assign q = rom[a];

endmodule