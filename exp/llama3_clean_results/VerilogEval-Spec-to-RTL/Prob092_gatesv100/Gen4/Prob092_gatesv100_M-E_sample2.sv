module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Generate out_both
    assign out_both = (in >> 1) & in;

    // Generate out_any
    assign out_any = (in << 1) | in;

    // Generate out_different
    assign out_different = (in ^ (in >> 1)) ^ ({1'b0, in[99:1]} ^ {in[0], in[99:1]});

endmodule