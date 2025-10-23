module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    reg [63:0] res;
    reg        borrow;
    integer    i;

    always @(*) begin
        borrow = 1'b0;
        for (i = 0; i < 64; i = i + 1) begin
            // Subtract bit by bit: result = A_bit - B_bit - borrow
            // Implement as full subtractor:
            // result bit = A[i] ^ B[i] ^ borrow
            // borrow out = (~A[i] & (B[i] | borrow)) | (B[i] & borrow)
            res[i] = A[i] ^ B[i] ^ borrow;
            borrow = (~A[i] & (B[i] | borrow)) | (B[i] & borrow);
        end
    end

    assign result = res;

    // Overflow detection for subtraction of signed numbers:
    // Overflow when sign of A and B differ, and sign of result differs from sign of A
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule