module TopModule (
    input [7:0] in,
    output [7:0] out
);

    assign out = in[0+:8];  // Equivalent to {in[0], in[1], ... in[7]}

endmodule