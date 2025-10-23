module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    assign out_both = ({4{in[3]}} & in) & (in << 1);
    assign out_any = (in | (in >> 1)) & {4{1'b1}} << 1;
    assign out_different = (in ^ (in << 1)) & {4{1'b1}} >> 1;

    // To handle the wrap-around case for out_different
    assign out_different[0] = in[0] ^ in[3];

endmodule