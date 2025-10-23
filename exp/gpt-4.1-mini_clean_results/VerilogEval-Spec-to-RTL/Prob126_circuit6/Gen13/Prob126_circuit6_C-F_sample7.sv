module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    // Declare a localparam ROM for constant values indexed by 'a'
    localparam [15:0] rom [0:7] = {
        16'h2f19,  // a=7
        16'hc526,  // a=6
        16'h64ce,  // a=5
        16'h2066,  // a=4
        16'h5a0e,  // a=3
        16'h27d4,  // a=2
        16'haee0,  // a=1
        16'h1232   // a=0
    };

    // Since the array is declared with index 0 at rightmost in initialization,
    // access with inverse index or reorder initialization so rom[a] matches a's index
    // Reorder initialization for ascending index for clarity:
    // rom[0] = 16'h1232; rom[1] = 16'haee0; ... rom[7] = 16'h2f19;

    // Re-declare properly ascending
    localparam [15:0] rom_asc [0:7] = {
        16'h1232,  // 0
        16'haee0,  // 1
        16'h27d4,  // 2
        16'h5a0e,  // 3
        16'h2066,  // 4
        16'h64ce,  // 5
        16'hc526,  // 6
        16'h2f19   // 7
    };

    // Assign output q from the localparam ROM indexed by a
    assign q = rom_asc[a];

endmodule