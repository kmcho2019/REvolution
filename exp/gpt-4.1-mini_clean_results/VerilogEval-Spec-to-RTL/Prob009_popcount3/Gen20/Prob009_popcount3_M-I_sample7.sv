module TopModule (
    input  [2:0] in,
    output [1:0] out
);
    // Compute population count by adding bits explicitly in a continuous assignment
    assign out = in[0] + in[1] + in[2];
endmodule