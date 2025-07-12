module TopModule(
    input  [2:0] in,
    output [1:0] out
);

    // Directly count the number of '1's in the input vector
    assign out = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]};

endmodule