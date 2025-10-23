module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    wire [1:0] partial_sum;

    // Add the first two bits and represent as 2-bit value
    assign partial_sum = {1'b0, in[0]} + {1'b0, in[1]};

    // Add the third bit to the partial sum
    assign out = partial_sum + {1'b0, in[2]};

endmodule