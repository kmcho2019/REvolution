module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Direct arithmetic approach to calculate population count
    assign out = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]};

    // This implementation is chosen for its simplicity, area efficiency, and ease of understanding.
    // It directly calculates the population count of the input vector 'in' and assigns it to 'out'.

endmodule