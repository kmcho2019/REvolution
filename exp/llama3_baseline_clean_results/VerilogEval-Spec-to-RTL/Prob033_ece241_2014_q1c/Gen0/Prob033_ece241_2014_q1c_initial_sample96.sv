module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);

    // Perform the addition, with the result being a 9-bit number
    wire [8:0] sum = {a[7], a} + {b[7], b};

    // Assign the result to the output, taking only the lower 8 bits
    assign s = sum[7:0];

    // Determine if an overflow has occurred by comparing the sign bit of the
    // 9-bit sum with the sign bit of the 8-bit sum
    assign overflow = sum[8] ^ sum[7];

endmodule