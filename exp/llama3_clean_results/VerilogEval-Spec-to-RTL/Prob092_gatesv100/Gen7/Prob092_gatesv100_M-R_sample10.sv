module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    assign out_both = in & (in >> 1);
    assign out_any  = ({1'b0, in} | in) & ~(1 << 100);
    assign out_different = in ^ ({in[0], in[99:1]});

endmodule