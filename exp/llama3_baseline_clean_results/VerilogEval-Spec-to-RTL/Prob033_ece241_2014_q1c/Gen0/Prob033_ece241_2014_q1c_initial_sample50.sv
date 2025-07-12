module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

    // Sign-extend a and b to 9 bits
    wire [8:0] a_ext = {{1'b1, a[7:0]}};
    wire [8:0] b_ext = {{1'b1, b[7:0]}};

    // Perform the addition as 9-bit numbers
    wire [8:0] sum_ext = a_ext + b_ext;

    // Assign the result, truncating back to 8 bits
    assign s = sum_ext[7:0];

    // Check for overflow
    assign overflow = sum_ext[8] ^ sum_ext[7];

endmodule