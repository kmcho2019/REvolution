module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Intermediate signals to hold the count of '1's in the input
    wire count_0 = in[0];
    wire count_1 = in[1];
    wire count_2 = in[2];

    // Directly calculate the output by adding the counts
    assign out[0] = count_0 | count_1 | count_2;
    assign out[1] = (count_0 & count_1) | (count_0 & count_2) | (count_1 & count_2);

    // Alternatively, consider using a single assign statement
    // assign out = {1'b0, in[0] & in[1] & in[2]} + {1'b0, in[0] & in[1]} + {1'b0, in[0] & in[2]} + {1'b0, in[1] & in[2]} + {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]};

endmodule