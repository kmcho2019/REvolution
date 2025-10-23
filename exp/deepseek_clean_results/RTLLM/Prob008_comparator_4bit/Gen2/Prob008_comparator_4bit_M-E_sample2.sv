module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire [3:0] bit_greater;
wire [3:0] bit_equal;
wire [3:0] bit_less;

// Generate comparison for each bit
genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin : bit_compare
        assign bit_greater[i] = A[i] & ~B[i];
        assign bit_equal[i]   = A[i] ~^ B[i];
        assign bit_less[i]    = ~A[i] & B[i];
    end
endgenerate

// Priority encoder for final result
assign A_greater = bit_greater[3] |
                  (bit_equal[3] & bit_greater[2]) |
                  (bit_equal[3] & bit_equal[2] & bit_greater[1]) |
                  (bit_equal[3] & bit_equal[2] & bit_equal[1] & bit_greater[0]);

assign A_equal = &bit_equal;

assign A_less = bit_less[3] |
               (bit_equal[3] & bit_less[2]) |
               (bit_equal[3] & bit_equal[2] & bit_less[1]) |
               (bit_equal[3] & bit_equal[2] & bit_equal[1] & bit_less[0]);

endmodule