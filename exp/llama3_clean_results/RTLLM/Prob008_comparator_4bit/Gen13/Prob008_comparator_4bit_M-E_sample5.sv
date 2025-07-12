module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    assign diff = A ^ B;

    wire [1:0] msb_diff;
    priority_encoder pe(.in(diff), .out(msb_diff));

    assign A_equal = ~(diff[0] | diff[1] | diff[2] | diff[3]);
    assign A_greater = ~(A_equal) && ((msb_diff == 2'b00 && A[3] == 1'b1 && B[3] == 1'b0) ||
                                    (msb_diff == 2'b01 && A[2] == 1'b1 && B[2] == 1'b0) ||
                                    (msb_diff == 2'b10 && A[1] == 1'b1 && B[1] == 1'b0) ||
                                    (msb_diff == 2'b11 && A[0] == 1'b1 && B[0] == 1'b0));
    assign A_less = ~(A_equal) && ~(A_greater);

endmodule

module priority_encoder(
    input  [3:0] in,
    output [1:0] out
);

    assign out = (in[3] == 1'b1) ? 2'b00 :
                 (in[2] == 1'b1) ? 2'b01 :
                 (in[1] == 1'b1) ? 2'b10 :
                 (in[0] == 1'b1) ? 2'b11 : 2'b00;

endmodule