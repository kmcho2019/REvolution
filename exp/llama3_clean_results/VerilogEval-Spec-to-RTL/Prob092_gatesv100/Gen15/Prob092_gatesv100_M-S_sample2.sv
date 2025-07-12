module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    assign out_both = (in >> 1) & in;
    assign out_both[99] = 1'b0;

    assign out_any = in | (in << 1);
    assign out_any[0] = 1'b0;

    assign out_different = in ^ (in >> 1);
    assign out_different[99] = in[99] ^ in[0];

endmodule