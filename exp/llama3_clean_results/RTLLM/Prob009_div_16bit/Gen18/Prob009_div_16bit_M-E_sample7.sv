module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [3:0] segment1, segment2, segment3, segment4;
reg [3:0] quotient1, quotient2, quotient3, quotient4;
reg [3:0] remainder1, remainder2, remainder3, remainder4;

always @(*) begin
    // Divide the 16-bit dividend into four 4-bit segments
    segment1 = A[15:12];
    segment2 = A[11:8];
    segment3 = A[7:4];
    segment4 = A[3:0];

    // Perform parallel division on each segment
    quotient1 = segment1 / B[7:4];
    quotient2 = segment2 / B[7:4];
    quotient3 = segment3 / B[7:4];
    quotient4 = segment4 / B[7:4];

    remainder1 = segment1 % B[7:4];
    remainder2 = segment2 % B[7:4];
    remainder3 = segment3 % B[7:4];
    remainder4 = segment4 % B[7:4];

    // Combine the results from each segment
    result = {quotient1, quotient2, quotient3, quotient4};
    odd = {remainder1, remainder2, remainder3, remainder4};
end

endmodule