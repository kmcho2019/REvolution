module comparator_4bit(
    input  wire [3:0] A,
    input  wire [3:0] B,
    output wire       A_greater,
    output wire       A_equal,
    output wire       A_less
);

    wire [3:0] diff;
    wire       borrow;

    assign diff[0] = A[0] - B[0];
    assign diff[1] = A[1] - B[1];
    assign diff[2] = A[2] - B[2];
    assign diff[3] = A[3] - B[3];

    assign borrow = (~A[0] & B[0]) | 
                   ((~A[1] & B[1]) & (A[0] == B[0])) | 
                   ((~A[2] & B[2]) & (A[1] == B[1]) & (A[0] == B[0])) | 
                   ((~A[3] & B[3]) & (A[2] == B[2]) & (A[1] == B[1]) & (A[0] == B[0]));

    assign A_greater = (~borrow) & (|(diff[3:0]));
    assign A_equal   = ~(borrow | (~borrow & |(diff[3:0])));
    assign A_less    = borrow;

endmodule