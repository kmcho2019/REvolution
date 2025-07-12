module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Combine inputs into a 4-bit index
    wire [3:0] index = {a, b, c, d};

    // 16-bit lookup table corresponding to the Karnaugh map
    // Bit order: index from 0 to 15 where index = abcd (a is MSB)
    // The table values correspond to the Karnaugh map pattern given
    //  index: 0 1 2 3  4 5 6 7  8 9 A B  C D E F (hex)
    //  out:   0 1 0 1  1 0 1 0  0 1 0 1  1 0 1 0
    localparam [15:0] LUT = 16'b0101101001011010;

    assign out = LUT[index];

endmodule