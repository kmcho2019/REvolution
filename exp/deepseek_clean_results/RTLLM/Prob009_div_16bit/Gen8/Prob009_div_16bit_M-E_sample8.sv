module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Segment the dividend into 4-bit chunks
    wire [3:0] seg3 = A[15:12];
    wire [3:0] seg2 = A[11:8];
    wire [3:0] seg1 = A[7:4];
    wire [3:0] seg0 = A[3:0];

    // First level processing (4-bit segments)
    wire [11:0] rem3 = {8'b0, seg3};
    wire cmp3 = (rem3 >= B);
    wire [7:0] diff3 = cmp3 ? (rem3 - B) : rem3[7:0];
    wire [3:0] quot3 = {4{cmp3}};

    wire [11:0] rem2 = {diff3, seg2};
    wire cmp2 = (rem2 >= B);
    wire [7:0] diff2 = cmp2 ? (rem2 - B) : rem2[7:0];
    wire [3:0] quot2 = {4{cmp2}};

    wire [11:0] rem1 = {diff2, seg1};
    wire cmp1 = (rem1 >= B);
    wire [7:0] diff1 = cmp1 ? (rem1 - B) : rem1[7:0];
    wire [3:0] quot1 = {4{cmp1}};

    wire [11:0] rem0 = {diff1, seg0};
    wire cmp0 = (rem0 >= B);
    wire [7:0] diff0 = cmp0 ? (rem0 - B) : rem0[7:0];
    wire [3:0] quot0 = {4{cmp0}};

    // Combine quotient segments with proper shifting
    assign result = {quot3, quot2, quot1, quot0};

    // Final remainder (zero-extended to 16 bits)
    assign odd = {8'b0, diff0};

    // Early termination optimization
    // If divisor is larger than current remainder, skip next segments
    // This is handled implicitly by the comparisons above

endmodule