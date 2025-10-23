module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    // Define a constant lookup table as a packed array
    wire [15:0] lookup_table [0:7];

    assign lookup_table[0] = 16'h1232;
    assign lookup_table[1] = 16'haee0;
    assign lookup_table[2] = 16'h27d4;
    assign lookup_table[3] = 16'h5a0e;
    assign lookup_table[4] = 16'h2066;
    assign lookup_table[5] = 16'h64ce;
    assign lookup_table[6] = 16'hc526;
    assign lookup_table[7] = 16'h2f19;

    // Output is selected from the lookup table by input 'a'
    assign q = lookup_table[a];

endmodule