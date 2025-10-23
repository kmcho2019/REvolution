module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output reg  [63:0] result,
    output reg         overflow
);

    // Internal sign bit signals
    wire sign_A = A[63];
    wire sign_B = B[63];
    reg  sign_res;

    always @* begin
        // Perform subtraction
        result = A - B;
        sign_res = result[63];

        // Detect overflow:
        // Positive overflow: A positive, B negative, result negative
        // Negative overflow: A negative, B positive, result positive
        if ((sign_A == 1'b0 && sign_B == 1'b1 && sign_res == 1'b1) ||
            (sign_A == 1'b1 && sign_B == 1'b0 && sign_res == 1'b0)) begin
            overflow = 1'b1;
        end else begin
            overflow = 1'b0;
        end
    end

endmodule