module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;

    assign diff[3] = A[3] &&!B[3];
    assign diff[2] = (!diff[3] && (A[2] &&!B[2]));
    assign diff[1] = (!diff[3] &&!diff[2] && (A[1] &&!B[1]));
    assign diff[0] = (!diff[3] &&!diff[2] &&!diff[1] && (A[0] &&!B[0]));

    assign A_greater = diff[3] || diff[2] || diff[1] || diff[0];

    assign A_equal =!(A > B) &&!(A < B);

    assign A_less =!A_greater &&!A_equal;

endmodule