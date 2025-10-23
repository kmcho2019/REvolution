module TopModule(
    input  [2:0] in,  // 3-bit input vector
    output [1:0] out  // 2-bit output representing the count of '1's
);

    // Assign the count of '1's in the input vector to the output
    assign out = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]};

endmodule