module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output      f
);

    // Name input bits for clarity
    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // Gray code to binary conversion for row bits (x3,x4)
    wire row1 = x3;
    wire row0 = x3 ^ x4;

    // Gray code to binary conversion for column bits (x1,x2)
    wire col1 = x1;
    wire col0 = x1 ^ x2;

    // Flatten address (not strictly needed here but kept for clarity)
    wire [3:0] addr = {row1, row0, col1, col0};

    // From the Karnaugh map after decoding Gray code to binary rows and cols:
    // Derive minimized sum-of-products for f (don't cares chosen to simplify):
    //
    // Mapping inputs to f with row = {x3,x3^x4}, col = {x1,x1^x2}
    // Derive f by inspection or Boolean algebra:
    //
    // One minimal expression derived (verified from K-map):
    // f = row1 & (~row0 | col1) | (~row1 & row0 & col1 & ~col0)
    //
    // Explanation:
    // - row1=1 & (~row0 + col1) covers cells with row=10 or 11 and columns 00,01 and cells that are 1.
    // - (~row1 & row0 & col1 & ~col0) covers the one '1' at row=01 col=10.
    //
    // This compact expression fits the K-map with don't-cares assigned to optimize logic.

    assign f = (row1 & (~row0 | col1)) | (~row1 & row0 & col1 & ~col0);

endmodule