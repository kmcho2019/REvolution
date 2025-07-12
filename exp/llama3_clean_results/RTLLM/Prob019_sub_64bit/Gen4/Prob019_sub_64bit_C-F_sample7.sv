module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output reg overflow
);

    wire [63:0] diff;
    reg sign_A, sign_B, sign_result;

    assign diff = A - B;
    assign sign_A = A[63];
    assign sign_B = B[63];
    assign sign_result = diff[63];

    always @(*) begin
        // Overflow detection logic
        overflow = (sign_A == 1'b0 && sign_B == 1'b1 && sign_result == 1'b1) ||
                   (sign_A == 1'b1 && sign_B == 1'b0 && sign_result == 1'b0);
    end

    assign result = diff;

endmodule