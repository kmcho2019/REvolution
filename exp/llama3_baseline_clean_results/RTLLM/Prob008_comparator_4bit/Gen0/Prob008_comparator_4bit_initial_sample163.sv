module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire [3:0] result;
wire B_out;

// Perform subtraction: A - B
full_subtractor fs0(A[0], B[0], 1'b0, result[0], B_out);
full_subtractor fs1(A[1], B[1], B_out, result[1], B_out);
full_subtractor fs2(A[2], B[2], B_out, result[2], B_out);
full_subtractor fs3(A[3], B[3], B_out, result[3], B_out);

// Determine comparison result
assign A_less = B_out;
assign A_equal = (~B_out) & (~|result); // ~|result checks if result is zero
assign A_greater = (~B_out) & (|result); // |result checks if result is non-zero

endmodule

// Full subtractor module
module full_subtractor(
    input A,
    input B,
    input Bin,
    output D,
    output Bout
);

assign D = A ^ B ^ Bin;
assign Bout = (A & (~B & Bin)) | (~A & B) | (~A & Bin & B);

endmodule