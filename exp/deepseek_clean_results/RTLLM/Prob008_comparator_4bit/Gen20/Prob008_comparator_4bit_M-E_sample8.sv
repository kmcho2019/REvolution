module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Create difference vector (1: A>B, 0: A=B, -1: A<B)
wire [3:0] diff_positive = A & ~B;
wire [3:0] diff_negative = ~A & B;

// Priority encoder to find first difference
wire first_diff_pos;
wire first_diff_neg;

assign first_diff_pos = diff_positive[3] | 
                       (!diff_negative[3] & diff_positive[2]) |
                       (!diff_negative[3] & !diff_negative[2] & diff_positive[1]) |
                       (!diff_negative[3] & !diff_negative[2] & !diff_negative[1] & diff_positive[0]);

assign first_diff_neg = diff_negative[3] | 
                       (!diff_positive[3] & diff_negative[2]) |
                       (!diff_positive[3] & !diff_positive[2] & diff_negative[1]) |
                       (!diff_positive[3] & !diff_positive[2] & !diff_positive[1] & diff_negative[0]);

// Final outputs
assign A_equal = (A == B);
assign A_greater = !A_equal & first_diff_pos;
assign A_less = !A_equal & first_diff_neg;

endmodule