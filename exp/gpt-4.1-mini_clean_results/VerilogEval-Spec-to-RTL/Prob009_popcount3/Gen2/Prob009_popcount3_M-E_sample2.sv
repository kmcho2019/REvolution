module TopModule(
    input  [2:0] in,
    output [1:0] out
);

    wire [1:0] sum_2bits;
    wire [2:0] extended_sum;

    // Sum the first two bits as a 2-bit number
    assign sum_2bits = {1'b0, in[0]} + {1'b0, in[1]};

    // Add the third bit as a 1-bit number to the 2-bit sum
    assign extended_sum = sum_2bits + in[2];

    // Output is the lower 2 bits of the final sum (max value 3)
    assign out = extended_sum[1:0];

endmodule