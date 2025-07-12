module sub_64bit(
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire         overflow
);

    // Speculative subtractor
    wire [63:0] spec_result;
    assign spec_result = A - B;

    // Correction unit
    wire [63:0] corr_result;
    wire borrow;
    assign borrow = (A < B) ? 1'b1 : 1'b0;
    assign corr_result = spec_result - {63'b0, borrow};

    // Overflow detection unit
    wire ovf;
    assign ovf = (A[63] == B[63] && A[63] != spec_result[63]) ? 1'b1 : 1'b0;

    // Final result and overflow
    assign result = corr_result;
    assign overflow = ovf;

endmodule