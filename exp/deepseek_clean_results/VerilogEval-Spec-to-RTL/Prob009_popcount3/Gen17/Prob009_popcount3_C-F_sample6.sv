module TopModule (
    input [2:0] in,
    output [1:0] out
);

    // Optimal fused solution: direct sum for efficiency and clarity
    assign out = in[0] + in[1] + in[2];

endmodule