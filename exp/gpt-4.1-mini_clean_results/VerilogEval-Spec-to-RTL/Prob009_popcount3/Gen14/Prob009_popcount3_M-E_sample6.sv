module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    wire [1:0] partial_sum;

    // Sum the least significant bits first
    assign partial_sum = {1'b0, in[0]} + {1'b0, in[1]};

    // Add the most significant bit to the partial sum
    assign out = partial_sum + {1'b0, in[2]};

endmodule