module TopModule(
    input [2:0] in,
    output [1:0] out
);

    wire [1:0] count_1bit;
    wire [1:0] count_2bit;

    // Count the number of '1's in the first two bits
    assign count_1bit = in[1] + in[0];

    // Count the number of '1's in the third bit and add it to the previous count
    assign count_2bit = in[2] + count_1bit;

    // Assign the result to the output
    assign out = count_2bit[1:0];

endmodule