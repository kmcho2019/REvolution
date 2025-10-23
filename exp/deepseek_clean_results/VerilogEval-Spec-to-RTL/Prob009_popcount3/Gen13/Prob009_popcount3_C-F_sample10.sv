module TopModule (
    input [2:0] in,
    output [1:0] out
);
    // Fused optimal population count:
    // Direct arithmetic sum of all bits, with implicit 2-bit output
    assign out = in[0] + in[1] + in[2];
endmodule