module TopModule (
    input [2:0] in,
    output [1:0] out
);
    // Optimal fused population count implementation
    // Direct sum with explicit output width
    assign out = in[0] + in[1] + in[2];
endmodule