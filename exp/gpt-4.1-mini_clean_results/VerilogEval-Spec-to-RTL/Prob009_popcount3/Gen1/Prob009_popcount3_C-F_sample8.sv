module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Sum the three input bits to compute the population count
    wire [2:0] sum_bits;
    assign sum_bits = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]};

    // Output is the 2 LSBs of the sum, representing counts 0 to 3
    assign out = sum_bits[1:0];

endmodule