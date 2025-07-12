module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    assign out_both = (in >> 1) & in;
    assign out_any = in | (in << 1);
    assign out_different = in ^ (in >> 1) | (in[3] ^ in[0]) << 3; // Simplified wrap-around logic

endmodule