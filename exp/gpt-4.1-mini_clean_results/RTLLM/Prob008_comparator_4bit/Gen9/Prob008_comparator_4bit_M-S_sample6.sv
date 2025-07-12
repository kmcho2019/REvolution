module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;  // bits where A and B differ

    assign diff = A ^ B;

    // Equality when no bits differ
    assign A_equal = (diff == 4'b0000);

    // For A_greater and A_less, find the highest differing bit
    // Priority encoding: check bits from MSB to LSB

    assign A_greater = 
        (diff[3] &  A[3]) |
        (~diff[3] & diff[2] &  A[2]) |
        (~diff[3] & ~diff[2] & diff[1] &  A[1]) |
        (~diff[3] & ~diff[2] & ~diff[1] & diff[0] &  A[0]);

    assign A_less = 
        (diff[3] & ~A[3]) |
        (~diff[3] & diff[2] & ~A[2]) |
        (~diff[3] & ~diff[2] & diff[1] & ~A[1]) |
        (~diff[3] & ~diff[2] & ~diff[1] & diff[0] & ~A[0]);

endmodule