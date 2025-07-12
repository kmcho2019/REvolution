module TopModule(
    input  [2:0] in,
    output [1:0] out
);

    wire [1:0] sum_bits;

    // Sum the individual bits as unsigned integers
    assign sum_bits = in[0] + in[1] + in[2];

    // Assign the sum to the output directly
    assign out = sum_bits;

endmodule