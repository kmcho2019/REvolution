module sub_64bit(
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Extend inputs to 65 bits by replicating sign bits
    wire [64:0] A_ext = {A[63], A};
    wire [64:0] B_ext = {B[63], B};

    // Perform 65-bit subtraction
    wire [64:0] res_ext = A_ext - B_ext;

    // Lower 64 bits as result
    assign result = res_ext[63:0];

    // Overflow detected if sign bit of 64-bit result differs from extended MSB
    assign overflow = (res_ext[64] != res_ext[63]);

endmodule