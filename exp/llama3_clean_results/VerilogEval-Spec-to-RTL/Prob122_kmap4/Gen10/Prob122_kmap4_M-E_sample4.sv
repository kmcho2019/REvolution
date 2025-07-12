module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Create a lookup table based on the Karnaugh map
    // The inputs 'a', 'b', 'c', 'd' form a 4-bit index into the table
    // Each entry in the table corresponds to a specific output from the Karnaugh map
    reg [1:0] lut [0:15];

    // Initialize the lookup table with values from the Karnaugh map
    initial begin
        lut[0]  = 1'b0;  // ab=00, cd=00
        lut[1]  = 1'b1;  // ab=00, cd=01
        lut[2]  = 1'b0;  // ab=00, cd=11
        lut[3]  = 1'b1;  // ab=00, cd=10
        lut[4]  = 1'b1;  // ab=01, cd=00
        lut[5]  = 1'b0;  // ab=01, cd=01
        lut[6]  = 1'b1;  // ab=01, cd=11
        lut[7]  = 1'b0;  // ab=01, cd=10
        lut[8]  = 1'b0;  // ab=11, cd=00
        lut[9]  = 1'b1;  // ab=11, cd=01
        lut[10] = 1'b0;  // ab=11, cd=11
        lut[11] = 1'b1;  // ab=11, cd=10
        lut[12] = 1'b1;  // ab=10, cd=00
        lut[13] = 1'b0;  // ab=10, cd=01
        lut[14] = 1'b1;  // ab=10, cd=11
        lut[15] = 1'b0;  // ab=10, cd=10
    end

    // Use the inputs to index into the lookup table and assign the output
    assign out = lut[{a, b, c, d}];

endmodule