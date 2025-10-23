module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire [2:0] bit_greater;
wire [2:0] bit_equal;
wire [2:0] bit_less;

// Bit-slice comparison cells
genvar i;
generate
    for (i = 0; i < 3; i = i + 1) begin : bit_comparator
        assign bit_greater[i] = A[i] & ~B[i];
        assign bit_equal[i] = ~(A[i] ^ B[i]);
        assign bit_less[i] = ~A[i] & B[i];
    end
endgenerate

// Priority encoding from MSB to LSB
assign A_greater = bit_greater[2] | 
                  (bit_equal[2] & bit_greater[1]) | 
                  (bit_equal[2] & bit_equal[1] & bit_greater[0]);

assign A_equal = bit_equal[2] & bit_equal[1] & bit_equal[0];

assign A_less = bit_less[2] | 
               (bit_equal[2] & bit_less[1]) | 
               (bit_equal[2] & bit_equal[1] & bit_less[0]);

endmodule