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
        if (sign_A!= sign_result && sign_A!= sign_B) begin
            overflow = 1'b1;
        end else begin
            overflow = 1'b0;
        end
    end

    assign result = diff;

endmodule