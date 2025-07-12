module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Comparison results (1 if row < column)
    wire a_lt_b = (a < b);
    wire a_lt_c = (a < c);
    wire a_lt_d = (a < d);
    wire b_lt_a = (b < a);
    wire b_lt_c = (b < c);
    wire b_lt_d = (b < d);
    wire c_lt_a = (c < a);
    wire c_lt_b = (c < b);
    wire c_lt_d = (c < d);
    wire d_lt_a = (d < a);
    wire d_lt_b = (d < b);
    wire d_lt_c = (d < c);

    // Calculate minimum scores (count of inputs that each is smaller than)
    wire [1:0] a_score = a_lt_b + a_lt_c + a_lt_d;
    wire [1:0] b_score = b_lt_a + b_lt_c + b_lt_d;
    wire [1:0] c_score = c_lt_a + c_lt_b + c_lt_d;
    wire [1:0] d_score = d_lt_a + d_lt_b + d_lt_c;

    // Select minimum based on highest score
    assign min = (a_score == 3) ? a :
                 (b_score == 3) ? b :
                 (c_score == 3) ? c :
                 (d_score == 3) ? d :
                 // Tie-breaker (shouldn't normally reach here for unsigned)
                 (a <= b && a <= c && a <= d) ? a :
                 (b <= c && b <= d) ? b :
                 (c <= d) ? c : d;

endmodule