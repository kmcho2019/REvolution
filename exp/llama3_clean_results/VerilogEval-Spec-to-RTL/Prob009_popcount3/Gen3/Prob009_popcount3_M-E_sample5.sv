module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    wire single_bit_count;
    wire two_bit_count;

    assign single_bit_count = in[2];
    assign two_bit_count = (in[1] & ~in[0]) | (~in[1] & in[0]) | (in[1] & in[0]);

    assign out = {single_bit_count, two_bit_count};

endmodule