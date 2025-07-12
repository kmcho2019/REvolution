module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    // Split the 64-bit operands into four 16-bit segments
    wire [15:0] A_high_high = A[63:48];
    wire [15:0] A_high_low  = A[47:32];
    wire [15:0] A_low_high  = A[31:16];
    wire [15:0] A_low_low   = A[15:0];

    wire [15:0] B_high_high = B[63:48];
    wire [15:0] B_high_low  = B[47:32];
    wire [15:0] B_low_high  = B[31:16];
    wire [15:0] B_low_low   = B[15:0];

    // Perform subtraction on each segment
    wire [15:0] sub_high_high;
    wire [15:0] sub_high_low;
    wire [15:0] sub_low_high;
    wire [15:0] sub_low_low;

    wire carry_high_high;
    wire carry_high_low;
    wire carry_low_high;

    assign {carry_high_high, sub_high_high} = A_high_high - B_high_high;
    assign {carry_high_low, sub_high_low}  = A_high_low  - B_high_low  - carry_high_high;
    assign {carry_low_high, sub_low_high}  = A_low_high  - B_low_high  - carry_high_low;
    assign {overflow,        sub_low_low}   = A_low_low   - B_low_low   - carry_low_high;

    // Combine the results
    assign result = {sub_high_high, sub_high_low, sub_low_high, sub_low_low};

endmodule