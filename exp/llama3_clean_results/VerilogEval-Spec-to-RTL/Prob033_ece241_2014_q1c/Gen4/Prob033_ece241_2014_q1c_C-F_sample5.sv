module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

    // Declare an intermediate signal for the sum to improve readability
    wire [8:0] sum_ext; // Extended to 9 bits to include carry

    // Perform the addition and include the carry in the sum
    assign sum_ext = {1'b0, a} + {1'b0, b};

    // Assign the result (sum) to the output port, excluding the carry bit
    assign s = sum_ext[7:0];

    // Detect overflow by checking if the most significant bit (sign bit) of the result differs from the sign bits of a and b
    assign overflow = (a[7] == b[7] && a[7]!= s[7]);

endmodule