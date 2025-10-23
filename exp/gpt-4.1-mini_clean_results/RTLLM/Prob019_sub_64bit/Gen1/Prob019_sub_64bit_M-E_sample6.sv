module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Split operands into lower and upper 32-bit parts
    wire [31:0] A_low  = A[31:0];
    wire [31:0] A_high = A[63:32];
    wire [31:0] B_low  = B[31:0];
    wire [31:0] B_high = B[63:32];

    // Stage 1: Subtract lower 32 bits
    wire [31:0] res_low;
    wire        borrow_low;
    assign {borrow_low, res_low} = {1'b0, A_low} - {1'b0, B_low};

    // Stage 2: Subtract upper 32 bits along with borrow from lower stage
    wire [31:0] res_high;
    wire        borrow_high;
    assign {borrow_high, res_high} = {1'b0, A_high} - {1'b0, B_high} - borrow_low;

    // Combine result halves
    assign result = {res_high, res_low};

    // Signed version of inputs and result to detect overflow
    wire signed [63:0] sA = A;
    wire signed [63:0] sB = B;
    wire signed [63:0] sR = result;

    // Overflow detection:
    // Overflow occurs if sign of result != sign of A - B (in 2's complement)
    // More precisely for subtraction overflow in 2's complement:
    // overflow = (A_sign != B_sign) && (R_sign != A_sign)
    wire A_sign = sA[63];
    wire B_sign = sB[63];
    wire R_sign = sR[63];
    assign overflow = (A_sign != B_sign) && (R_sign != A_sign);

endmodule