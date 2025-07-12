module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    // Internal wires for result and overflow
    wire [63:0] internal_result;
    wire       internal_overflow;

    // Perform subtraction
    assign internal_result = A - B;

    // Predict potential overflow by examining the most significant bits of A and B
    wire [1:0] msb_AB;
    assign msb_AB = {A[63], B[63]};

    // Overflow prediction logic
    wire predict_overflow;
    assign predict_overflow = (msb_AB == 2'b01) || (msb_AB == 2'b10);

    // Actual overflow detection based on the result's sign bit
    assign internal_overflow = (A[63] != internal_result[63]) && predict_overflow;

    // Final result and overflow output
    assign result = internal_result;
    assign overflow = internal_overflow;

endmodule