module TopModule (
    input [2:0] in,
    output [1:0] out
);
    // Optimized population count with balanced addition tree
    assign out = (in[0] + in[1]) + in[2];
endmodule