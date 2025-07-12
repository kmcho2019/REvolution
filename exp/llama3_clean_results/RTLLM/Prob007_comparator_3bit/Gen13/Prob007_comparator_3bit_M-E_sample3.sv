module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

    // Compare MSB
    reg msb_greater, msb_equal, msb_less;
    assign msb_greater = (A[2] > B[2]);
    assign msb_equal = (A[2] == B[2]);
    assign msb_less = (A[2] < B[2]);

    // Compare middle bit if MSB is equal
    reg mid_greater, mid_equal, mid_less;
    assign mid_greater = (msb_equal && (A[1] > B[1]));
    assign mid_equal = (msb_equal && (A[1] == B[1]));
    assign mid_less = (msb_equal && (A[1] < B[1]));

    // Compare LSB if MSB and middle bit are equal
    reg lsb_greater, lsb_equal, lsb_less;
    assign lsb_greater = (msb_equal && mid_equal && (A[0] > B[0]));
    assign lsb_equal = (msb_equal && mid_equal && (A[0] == B[0]));
    assign lsb_less = (msb_equal && mid_equal && (A[0] < B[0]));

    // Determine final comparison result
    assign A_greater = msb_greater || mid_greater || lsb_greater;
    assign A_equal = (msb_equal && mid_equal && lsb_equal);
    assign A_less = msb_less || mid_less || lsb_less;

endmodule