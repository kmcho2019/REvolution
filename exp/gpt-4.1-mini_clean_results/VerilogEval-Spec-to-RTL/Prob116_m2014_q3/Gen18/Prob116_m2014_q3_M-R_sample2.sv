module TopModule (
    input  [3:0] x,   // x[3] = x4, x[2] = x3, x[1] = x2, x[0] = x1 (problem order)
    output      f
);

    // Assign names for clarity
    wire x1 = x[0]; // problem x[1]
    wire x2 = x[1]; // problem x[2]
    wire x3 = x[2]; // problem x[3]
    wire x4 = x[3]; // problem x[4]

    // Combine inputs as {x3,x4,x1,x2} for direct indexing
    // Because the Karnaugh map's rows use x3 x4 and columns use x1 x2
    wire [3:0] addr = {x3, x4, x1, x2};

    // Assign f using a case on all input combinations, flattening nested cases
    assign f = (addr == 4'b0000) ? 1'b0 :  // row 00 col 00: d->0
               (addr == 4'b0001) ? 1'b0 :  // row 00 col 01: 0
               (addr == 4'b0011) ? 1'b0 :  // row 00 col 11: d->0
               (addr == 4'b0010) ? 1'b0 :  // row 00 col 10: d->0
               (addr == 4'b0100) ? 1'b0 :  // row 01 col 00: 0
               (addr == 4'b0101) ? 1'b0 :  // row 01 col 01: d->0
               (addr == 4'b0111) ? 1'b1 :  // row 01 col 11: 1
               (addr == 4'b0110) ? 1'b0 :  // row 01 col 10: 0
               (addr == 4'b1100) ? 1'b1 :  // row 11 col 00: 1
               (addr == 4'b1101) ? 1'b1 :  // row 11 col 01: 1
               (addr == 4'b1111) ? 1'b0 :  // row 11 col 11: d->0
               (addr == 4'b1110) ? 1'b0 :  // row 11 col 10: d->0
               (addr == 4'b1000) ? 1'b1 :  // row 10 col 00: 1
               (addr == 4'b1001) ? 1'b1 :  // row 10 col 01: 1
               (addr == 4'b1011) ? 1'b0 :  // row 10 col 11: 0
               (addr == 4'b1010) ? 1'b0 :  // row 10 col 10: d->0
               1'b0;                       // default (should not occur)

endmodule