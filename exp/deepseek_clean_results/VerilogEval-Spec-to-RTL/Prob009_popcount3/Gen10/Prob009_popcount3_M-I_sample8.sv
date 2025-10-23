module TopModule (
    input [2:0] in,
    output [1:0] out
);

    // Population count for 3-bit input
    // Explicit 2-bit addition of input bits
    assign out = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]};

endmodule