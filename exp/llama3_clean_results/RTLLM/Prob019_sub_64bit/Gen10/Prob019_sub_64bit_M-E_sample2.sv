module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    // Predict potential overflow by examining the most significant bits of A and B
    wire [1:0] msb_AB;
    assign msb_AB = {A[63], B[63]};

    // Overflow prediction logic
    wire predict_overflow;
    assign predict_overflow = (msb_AB == 2'b01) || (msb_AB == 2'b10);

    // Perform subtraction
    assign result = A - B;

    // Actual overflow detection based on the result's sign bit
    wire actual_overflow;
    assign actual_overflow = (A[63]!= result[63]) && predict_overflow;

    // Final overflow output
    assign overflow = actual_overflow;

endmodule