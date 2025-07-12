module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output      A_greater,
    output      A_equal,
    output      A_less
);

    assign A_equal = (A == B);
    assign A_greater = (A > B) & ~A_equal;
    assign A_less = (A < B) & ~A_equal;

    // Alternative implementation using subtraction
    // wire [4:0] diff;
    // assign diff = {1'b0, A} - {1'b0, B};
    // assign A_greater = diff[4] == 0 && diff[3:0]!= 0;
    // assign A_equal = diff[4:0] == 0;
    // assign A_less = diff[4] == 1;

endmodule