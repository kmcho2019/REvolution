module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    wire [2:0] sum_bits;
    assign sum_bits = in[0] + in[1] + in[2];
    assign out = sum_bits[1:0]; // Only lower 2 bits needed, max sum is 3 (2'b11)

endmodule