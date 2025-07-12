module TopModule (
    input [2:0] in,
    output [1:0] out
);

    // Population count: sum of '1's in the 3-bit input
    assign out = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]};

endmodule