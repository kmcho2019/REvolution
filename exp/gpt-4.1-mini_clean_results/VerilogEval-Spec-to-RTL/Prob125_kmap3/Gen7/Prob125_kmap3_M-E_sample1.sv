module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,  // don't-care
    output out
);

    // Build address lines for a 4x4 ROM:
    // Row address: {c, d} (2 bits)
    // Column address: {a, b} (2 bits)
    // Since d is don't-care, we fix it to 0 for address indexing.

    wire [1:0] row = {c, 1'b0};   // fix d=0
    wire [1:0] col = {a, b};

    wire [3:0] rom_row0 = 4'b0111; // c=0, d=0 row from K-map with d=0 col order 01 00 10 11 (ab)
    wire [3:0] rom_row1 = 4'b0000; // c=0, d=1 row fixed to zeros (since d is don't-care, safe)
    wire [3:0] rom_row2 = 4'b0111; // c=1, d=0 row 
    wire [3:0] rom_row3 = 4'b0000; // c=1, d=1 row fixed zeros

    wire [3:0] rom_data [3:0];

    assign rom_data[0] = rom_row0;
    assign rom_data[1] = rom_row1;
    assign rom_data[2] = rom_row2;
    assign rom_data[3] = rom_row3;

    // Output is rom_data[row][col]
    assign out = rom_data[row][col];

endmodule