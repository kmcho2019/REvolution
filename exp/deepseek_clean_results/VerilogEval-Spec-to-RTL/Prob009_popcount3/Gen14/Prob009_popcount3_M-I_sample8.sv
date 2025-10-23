module TopModule (
    input [2:0] in,
    output [1:0] out
);
    // Optimized population count with balanced adder tree
    // First add two bits, then add the third
    wire [1:0] partial_sum = {1'b0, in[0]} + {1'b0, in[1]};
    assign out = partial_sum + {1'b0, in[2]};
endmodule