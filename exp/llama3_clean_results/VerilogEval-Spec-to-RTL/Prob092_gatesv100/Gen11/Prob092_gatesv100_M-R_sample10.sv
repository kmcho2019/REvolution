module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Calculate out_both vector
    assign out_both = (in << 1) & in;

    // Calculate out_any vector
    assign out_any = in | (in >> 1);

    // Calculate out_different vector
    assign out_different = in ^ ({in[0], in[99:1]});

endmodule