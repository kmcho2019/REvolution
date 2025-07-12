module TopModule (
    input [2:0] in,
    output [1:0] out
);
    // Optimized population count with clear bit-width handling
    // Directly sums bits with implicit 2-bit result
    assign out = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]};
endmodule