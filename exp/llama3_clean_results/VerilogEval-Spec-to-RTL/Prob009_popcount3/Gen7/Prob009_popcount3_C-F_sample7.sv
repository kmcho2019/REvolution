module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Simplified arithmetic approach, ensuring correct handling of bit widths
    assign out = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]};

    // This implementation maintains simplicity, efficiency, and correct arithmetic operation
    // while ensuring the output is correctly represented as a 2-bit vector.

endmodule