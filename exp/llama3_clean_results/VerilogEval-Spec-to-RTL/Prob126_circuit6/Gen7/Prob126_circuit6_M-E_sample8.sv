module TopModule(
    input [2:0] a,
    output [15:0] q
);

// Define the ROM
reg [15:0] rom [7:0];

// Initialize the ROM
initial begin
    rom[0] = 16'h1232;
    rom[1] = 16'haee0;
    rom[2] = 16'h27d4;
    rom[3] = 16'h5a0e;
    rom[4] = 16'h2066;
    rom[5] = 16'h64ce;
    rom[6] = 16'hc526;
    rom[7] = 16'h2f19;
end

// Use the ROM to assign the output
assign q = rom[a];

endmodule