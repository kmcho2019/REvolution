module TopModule (
    input  [3:0] x,  // input bits: {x3, x2, x1, x0} corresponds directly to the Gray-coded indices
    output      f
);

    // The mapping based on the Karnaugh map with input as x[3:0]:
    // Each index corresponds to the Gray-coded address: {x3 x2 x1 x0}
    // Here, we use x directly as the address to the LUT.
    //
    // Karnaugh map to LUT index mapping:
    // x = {x3 x2 x1 x0} where
    // x3,x2 = row bits (Gray-coded)
    // x1,x0 = column bits (Gray-coded)
    //
    // For input x = b3 b2 b1 b0,
    // assign LUT[x] = function value from K-map (d -> 0)

    // LUT entries (index = x):
    // Index : Value (from K-map; d replaced with 0)
    // 0  (0000) : d -> 0
    // 1  (0001) : 0
    // 2  (0010) : d -> 0
    // 3  (0011) : d -> 0
    // 4  (0100) : 0
    // 5  (0101) : d -> 0
    // 6  (0110) : 1
    // 7  (0111) : 0
    // 8  (1000) : 1
    // 9  (1001) : 1
    // 10 (1010) : 0
    // 11 (1011) : 0
    // 12 (1100) : 1
    // 13 (1101) : 1
    // 14 (1110) : 0
    // 15 (1111) : 0

    // Define a 16-bit vector representing the LUT, LSB corresponds to index 0
    localparam [15:0] LUT = 16'b0000_0110_1100_0010;

    // Assign output by indexing the LUT with input x
    assign f = LUT[x];

endmodule