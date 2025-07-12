module TopModule(
    input  [3:0] x,
    output       f
);

    // The Karnaugh map is indexed by rows = {x[2], x[3]}, columns = {x[0], x[1]}
    // Form the 4-bit LUT address by concatenating row bits and column bits:
    // Address = {x[2], x[3], x[0], x[1]}
    //
    // The LUT bit order is such that bit 0 corresponds to addr=0b0000,
    // bit 15 corresponds to addr=0b1111, matching Karnaugh map arrangement.

    localparam [15:0] LUT = 16'b1011011100000101; // LUT from Karnaugh map

    wire [3:0] addr = {x[2], x[3], x[0], x[1]};

    assign f = LUT[addr];

endmodule