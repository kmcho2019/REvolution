module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    assign out_both = in && (in << 1);
    assign out_any = in || (in >> 1);
    assign out_different = in ^ ((in << 1) | (in >> 99));

endmodule