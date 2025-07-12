module TopModule(
    input  [7:0] in,
    output [7:0] out
);
    // Reverse bit order: out[7] = in[0], out[6] = in[1], ..., out[0] = in[7]
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};
endmodule