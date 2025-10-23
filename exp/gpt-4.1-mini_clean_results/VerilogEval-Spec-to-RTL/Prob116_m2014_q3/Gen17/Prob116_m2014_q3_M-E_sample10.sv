module TopModule (
    input  [3:0] x,  // x[3] = problem x4, x[2] = x3, x[1] = x2, x[0] = x1
    output        f
);

    // For clarity, map problem bits
    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // Create 4-bit address as per problem order: {x4,x3,x2,x1}
    wire [3:0] addr = {x4, x3, x2, x1};

    // Define the LUT from Karnaugh map with don't-cares set to 0.
    // Karnaugh map rows: x3x4, columns: x1x2 (from problem)
    // But since addr is {x4,x3,x2,x1}, remap accordingly:
    //
    // Problem Karnaugh map (x3x4 rows, x1x2 columns):
    // rows: 00,01,11,10
    // cols: 00,01,11,10
    //
    // Reorder addr bits to match map indices: 
    // row_index = {x3,x4}, col_index = {x1,x2}
    // Here addr = {x4,x3,x2,x1}
    // so need to swap bits to get row and column:
    // row = {x3,x4} = {addr[2], addr[3]}
    // col = {x1,x2} = {addr[0], addr[1]}
    //
    // To index LUT, transform addr into {row, col} = {addr[2], addr[3], addr[0], addr[1]}
    // We'll implement LUT indexed by transformed_addr:
    //
    wire [3:0] lut_addr = {addr[2], addr[3], addr[0], addr[1]};

    // LUT values corresponding to each cell (row,col) from the map (assign d=0):
    // row=00(0), col=00(0) -> d=0
    // row=00(0), col=01(1) -> 0
    // row=00(0), col=11(3) -> d=0
    // row=00(0), col=10(2) -> d=0
    // row=01(1), col=00(0) -> 0
    // row=01(1), col=01(1) -> d=0
    // row=01(1), col=11(3) -> 1
    // row=01(1), col=10(2) -> 0
    // row=11(3), col=00(0) -> 1
    // row=11(3), col=01(1) -> 1
    // row=11(3), col=11(3) -> d=0
    // row=11(3), col=10(2) -> d=0
    // row=10(2), col=00(0) -> 1
    // row=10(2), col=01(1) -> 1
    // row=10(2), col=11(3) -> 0
    // row=10(2), col=10(2) -> d=0

    localparam [15:0] LUT = 16'b_0000_1000_1100_1110;

    assign f = LUT[lut_addr];

endmodule