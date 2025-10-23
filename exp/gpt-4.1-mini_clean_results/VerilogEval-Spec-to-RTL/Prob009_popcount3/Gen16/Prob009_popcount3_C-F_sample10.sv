module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Compute the sum of all input bits as a 3-bit intermediate
    wire [2:0] sum = in[0] + in[1] + in[2];

    // Assign output as the lower 2 bits of the sum (population count fits in 2 bits)
    assign out = sum[1:0];

endmodule