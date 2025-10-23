module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] result;

    // Perform subtraction A - B
    assign result = A - B;

    // Determine if A is greater than B
    assign A_greater = (result > 0);

    // Determine if A is equal to B
    assign A_equal = (result == 0);

    // Determine if A is less than B
    assign A_less = (result < 0);

    // Alternative approach using bit-level comparison
    // assign A_greater = (A[3] &&!B[3]) || (A[3] == B[3] && (A[2] &&!B[2] || (A[2] == B[2] && (A[1] &&!B[1] || (A[1] == B[1] && A[0] &&!B[0])))));
    // assign A_equal = (A[3] == B[3] && A[2] == B[2] && A[1] == B[1] && A[0] == B[0]);
    // assign A_less = (!A[3] && B[3]) || (A[3] == B[3] && (!A[2] && B[2] || (A[2] == B[2] && (!A[1] && B[1] || (A[1] == B[1] &&!A[0] && B[0])))));

endmodule