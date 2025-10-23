module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Simple adder approach, leveraging the fact that in Verilog, 
    // a bit treated as an integer is '1' for 1 and '0' for 0.
    assign out = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]};

    // This implementation maintains the simplicity of the arithmetic approach
    // while ensuring that the output is correctly represented as a 2-bit vector.

endmodule