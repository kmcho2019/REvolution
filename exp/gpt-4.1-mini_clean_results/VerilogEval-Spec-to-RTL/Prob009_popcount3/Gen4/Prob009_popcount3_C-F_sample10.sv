module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Intermediate wire for summing bits explicitly
    wire [1:0] sum_bits;

    assign sum_bits = in[0] + in[1] + in[2];
    assign out = sum_bits;

endmodule