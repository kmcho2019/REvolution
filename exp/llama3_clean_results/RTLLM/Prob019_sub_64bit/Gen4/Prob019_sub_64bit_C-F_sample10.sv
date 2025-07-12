module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    wire [63:0] diff;
    reg sign_A, sign_B, sign_result;

    assign diff = A - B;
    assign sign_A = A[63];
    assign sign_B = B[63];
    assign sign_result = diff[63];

    always @(*) begin
        // Simplified overflow detection using bitwise operations
        overflow = (sign_A != sign_B) && (sign_A != sign_result);
    end

    assign result = diff;

endmodule